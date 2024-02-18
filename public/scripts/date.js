function updateDateTime() {
  const dateTimeContainer = document.getElementById('dateTimeContainer');
  const currentDate = new Date();

  const dayOfWeek = getDayOfWeekName(currentDate.getDay());
  const time =
    currentDate.getHours() +
    ':' +
    formatMinutesSeconds(currentDate.getMinutes()) +
    ':' +
    formatMinutesSeconds(currentDate.getSeconds());

  const date =
    formatMonthName(currentDate.getMonth()) +
    '\t' +
    currentDate.getDate() +
    ', ' +
    currentDate.getFullYear();

  const dateTimeString = dayOfWeek + ' | ' + time + '<br />' + date;

  dateTimeContainer.innerHTML = dateTimeString;
  setTimeout(updateDateTime, 1000);
}

function getDayOfWeekName(dayOfWeek) {
  const daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ]
  return daysOfWeek[dayOfWeek]
}

function formatMinutesSeconds(value) {
  return value < 10 ? '0' + value : value
}

function formatMonthName(month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ]
  return months[month]
}
