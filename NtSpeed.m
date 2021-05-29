// Julioverne's code for NtSpeed

static __strong NSString* kBs = @"%ldB/s";
static __strong NSString* kKs = @"%.0fK/s";
static __strong NSString* kMs = @"%.0fM/s";
static __strong NSString* kGs = @"%.0fG/s";


static NSString *bytesFormat(long bytes)
{
	@autoreleasepool {
		if(bytes < 1024) {
			return [NSString stringWithFormat:kBs, bytes];
		} else if(bytes >= 1024 && bytes < 1024 * 1024) {
			return [NSString stringWithFormat:kKs, round((double)bytes / 1024)];
		} else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) {
			return [NSString stringWithFormat:kMs, round((double)bytes / (1024 * 1024))];
		} else {
			return [NSString stringWithFormat:kGs, round((double)bytes / (1024 * 1024 * 1024))];
		}
	}
}

static long getBytesTotal()
{
	@autoreleasepool {
		uint32_t iBytes = 0;
		uint32_t oBytes = 0;
		struct ifaddrs *ifa_list = NULL, *ifa;
		if ((getifaddrs(&ifa_list) < 0) || !ifa_list || ifa_list==0) {
			return 0;
		}
		for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
			if (ifa->ifa_addr == NULL) {
				continue;
			}
			if (AF_LINK != ifa->ifa_addr->sa_family) {
				continue;
			}
			if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
				continue;
			}
			if (ifa->ifa_data == NULL || ifa->ifa_data == 0) {
				continue;
			}
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			iBytes += if_data->ifi_ibytes;
			oBytes += if_data->ifi_obytes;
		}
		if(ifa_list) {
			freeifaddrs(ifa_list);
		}
		return iBytes + oBytes;
	}
}

static long oldSpeed = 0;

// Combination of my code and Julioverne's
static NSString *getNetworkSpeedString()
{
	@autoreleasepool {
		try_again:
		long nowData = 0;
		getBytesTotal();
		while(nowData <= 0) {
			nowData = getBytesTotal();
		}
		if(!oldSpeed) {
			oldSpeed = nowData;
		}
		long speed = nowData-oldSpeed;
		oldSpeed = nowData;
		if(oldSpeed <= 0) {
			goto try_again;
		}
		return bytesFormat(speed);
	}
}
