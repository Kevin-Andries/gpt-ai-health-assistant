export async function isUserPremium(revenueCatAppUserId) {
  const res = await fetch(
    `https://api.revenuecat.com/v1/subscribers/${revenueCatAppUserId}`,
    {
      headers: {
        Authorization: `Bearer ${process.env.REVENUECAT_SECRET_KEY}`,
        "Content-Type": "application/json",
      },
    }
  );

  const data = await res.json();

  if (
    data &&
    data.subscriber &&
    data.subscriber.entitlements &&
    data.subscriber.entitlements.premium
  ) {
    return true;
  } else {
    return false;
  }
}
