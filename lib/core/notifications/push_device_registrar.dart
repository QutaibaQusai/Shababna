abstract interface class PushDeviceRegistrar {
  Future<void> refresh({bool force = false});
}
