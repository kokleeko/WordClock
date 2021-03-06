/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebView>
#include <memory>

#include "DeviceAccess.h"

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
  QtWebView::initialize();
  QGuiApplication app(argc, argv);
  app.setOrganizationName("Kokleeko S.L.");
  app.setOrganizationDomain("kokleeko.io");
  app.setApplicationName("WordClock");
  app.setApplicationVersion("1.0.0");
  QQmlApplicationEngine engine;

  using namespace kokleeko::device;
  engine.rootContext()->setContextProperty("DeviceAccess",
                                           &DeviceAccess::instance());
  const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);
#ifdef Q_OS_WASM
  QObject::connect(&DeviceAccess::instance(), &DeviceAccess::settingsReady,
                   &app, [url, &engine]() {
#endif
                     engine.load(url);
#ifdef Q_OS_WASM
                   });
#endif
  return app.exec();
}
