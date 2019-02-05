local Observable = require("LuaObservable")

Observable.loadExtensions()

Observable.range(1, 10):merge(Observable.range(11, 20)):subscribe(print, print)