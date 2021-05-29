VolumeControl *volumeControl = [NSClassFromString(@"VolumeControl") sharedVolumeControl];

static NSString *getVolumeString() {
  return [NSString stringWithFormat:@"Vol %i%%", (int)([volumeControl getMediaVolume] * 100)];
}
