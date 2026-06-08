function getTodayDateString() {
  return new Date().toISOString().slice(0, 10);
}

function normalizeBookingDate(value) {
  if (!value || String(value).trim().toLowerCase() === "today") {
    return getTodayDateString();
  }

  const date = String(value).trim();

  if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    return null;
  }

  return date;
}

function formatAmPm(hour, minute) {
  const suffix = hour >= 12 ? "PM" : "AM";
  const displayHour = hour % 12 || 12;
  return `${displayHour}:${String(minute).padStart(2, "0")} ${suffix}`;
}

function parseArrivalTime(value) {
  const input = String(value || "").trim();
  let match = input.match(/^([01]?\d|2[0-3]):([0-5]\d)$/);

  if (match) {
    const hour = Number(match[1]);
    const minute = Number(match[2]);
    return { hour, minute, label: formatAmPm(hour, minute) };
  }

  match = input.match(/^(0?[1-9]|1[0-2]):([0-5]\d)\s*(AM|PM)$/i);

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
  const endHour = endAt.getUTCHours();
  const endMinute = endAt.getUTCMinutes();

  return {
    arrivalTime: parsedTime.label,
    startAt,
    endAt,
    timeRange: `${parsedTime.label} - ${formatAmPm(endHour, endMinute)}`,
  };
}

module.exports = {
  buildBookingWindow,
  getTodayDateString,
  normalizeBookingDate,
  parseArrivalTime,
};
