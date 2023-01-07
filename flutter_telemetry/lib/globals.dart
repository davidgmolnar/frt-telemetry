String activeTab = "CONFIG";

// settings  [val, min, max]
Map<String, dynamic> settings = {
  "refreshTimeMS" : [100,50,2000],
  "chartrefreshTimeMS": [10,5,2000],
  "signalValuesToKeep": [128,48,1024],
  "chartSignalValuesToKeep": [128,48,1024],
};

Map<String, String> settingsToLabel = {
  "refreshTimeMS" : "Refresh time in ms",
  "chartrefreshTimeMS": "Chart refresh time in ms",
  "signalValuesToKeep": "Internal buffer",
  "chartSignalValuesToKeep": "Data points on chart",
};