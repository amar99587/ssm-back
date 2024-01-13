exports.toDate = (e, type = 'date') => {
    const newDate = new Date(e);
    let date = {
        year: newDate.getFullYear(),
        month: String(newDate.getMonth()+1).padStart(2,'0'),
        day: String(newDate.getDate()).padStart(2,'0'),
        hours: String(newDate.getHours()).padStart(2,'0'),
        minutes: String(newDate.getMinutes()).padStart(2,'0'),
    };
    const types = {
        date: `${date.year}-${date.month}-${date.day}`,
        timestamp: `${date.year}-${date.month}-${date.day} ${date.hours}:${date.minutes}`
    }
    if (!['date', 'timestamp'].includes(type)) { type = null }
    return type ? types[type] : date;
};