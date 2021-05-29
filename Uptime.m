// Thanks to Russell Quinn from StackOverflow
static NSString *getUptimeString() {
    struct timeval boottime;

    int mib[2] = {CTL_KERN, KERN_BOOTTIME};

    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;

    (void)time(&now);

    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }

    int hours = (int)uptime/(60*60);
    int days = (int)hours/24;
    hours -= (days*24);
    if(days > 0) {
      return [NSString stringWithFormat:@"%id %ih", days, hours];
    }
    else {
      return [NSString stringWithFormat:@"%ih", (int)uptime/(60*60)];
    }
}
