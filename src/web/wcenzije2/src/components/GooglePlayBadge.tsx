'use client';

import Image from 'next/image';
import posthog from 'posthog-js';

const GooglePlayBadge = () => {
  function submitPhEvent() {
    posthog.capture('google_play_badge_clicked');
  }

  return (
    <a
      href="https://play.google.com/store/apps/details?id=com.kova98.wcenzije&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1"
      onClick={submitPhEvent}
    >
      <Image
        width={180}
        height={53}
        alt="Get it on Google Play"
        src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg"
      />
    </a>
  );
};

export default GooglePlayBadge;
