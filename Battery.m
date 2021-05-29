static UIDevice *device = [UIDevice currentDevice];

static NSString *getBatteryString() {
  return [NSString stringWithFormat:@"%i%%", (int)([device batteryLevel] * 100)];
}
