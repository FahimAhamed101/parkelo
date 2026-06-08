function pad(value) {
  return String(value).padStart(2, "0");
}

function getTodayString() {
  const now = new Date();
  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;
}

function normalizeBookingDate(value) {
  if (!value || String(value).toLowerCase() === "today") {
    return getTodayString();
  }

  const date = String(value).trim();

  if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    return null;
  }

  return date;
}

function formatAmPm(hour, minute) {
  const suffix = hour >= 12 ? "PM" : "AM";
  const hour12 = hour % 12 || 12;
  return `${hour12}:${pad(minute)} ${suffix}`;
}

function parseArrivalTime(value) {
  const input = String(value || "").trim();
  let match = input.match(/^([01]?\d|2[0-3]):([0-5]\d)$/);

  if (match) {
    const hour = Number(match[1]);
    const minute = Number(match[2]);
    return { hour, minute, label: formatAmPm(hour, minute) };
  }

  match = input.match(/^(0?[1-9]|1[0-2]):([0-5]\d)\s*([AP]M)$/i);

  if (!match) {
    return null;
  }

  let hour = Number(match[1]);
  const minute = Number(match[2]);
  const suffix = match[3].toUpperCase();

  if (suffix === "PM" && hour !== 12) {
    hour += 12;
  }

  if (suffix === "AM" && hour === 12) {
    hour = 0;
  }

  return { hour, minute, label: formatAmPm(hour, minute) };
}

function buildBookingWindow(date, arrivalTime, durationHours) {
  const parsedTime = parseArrivalTime(arrivalTime);

  if (!parsedTime) {
    return null;
  }

  const [year, month, day] = date.split("-").map(Number);
  const startAt = new Date(Date.UTC(year, month - 1, day, parsedTime.hour, parsedTime.minute, 0));
  const endAt = new Date(startAt.getTime() + durationHours * 60 * 60 * 1000);

  return {
    startAt,
    endAt,
    arrivalTime: parsedTime.label,
    timeRange: `${parsedTime.label} - ${formatAmPm(endAt.getUTCHours(), endAt.getUTCMinutes())}`,
  };
}

function formatDuration(hours) {
  return hours === 1 ? "1 hour" : `${hours} hours`;
}

function formatTimer(milliseconds) {
  const totalSeconds = Math.max(0, Math.floor(milliseconds / 1000));
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
}

module.exports = {
  buildBookingWindow,
  formatDuration,
  formatTimer,
  getTodayString,
  normalizeBookingDate,
};
