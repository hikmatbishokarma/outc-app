enum AppModule { flights, hotels, cars, visa, bus }

class ModuleRegistry {
  static const Set<AppModule> enabledModules = {
    AppModule.flights,
    AppModule.hotels,
    AppModule.cars,
    AppModule.visa,
    AppModule.bus,
  };
  static const bool agentEnabled = true;

  static bool isEnabled(AppModule module) => enabledModules.contains(module);
}
