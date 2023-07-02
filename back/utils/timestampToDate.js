export function timestampToDate(timestamp) {
  const date = new Date(timestamp);
  const dateString = date.toDateString();

  let hours = date.getHours();
  let minutes = date.getMinutes();
  let seconds = date.getSeconds();

  if (hours < 10) hours = "0" + hours;
  if (minutes < 10) minutes = "0" + minutes;
  if (seconds < 10) seconds = "0" + seconds;

  const timeString = `${hours}:${minutes}:${seconds}`;

  return `${dateString} ${timeString}`;
}
