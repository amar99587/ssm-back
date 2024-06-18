SELECT p.student AS student, s.name AS name, SUM(p.quantity) AS quantity
FROM payments p
JOIN students s ON p.student = s.uid
WHERE p.course = '42fbae29-e9ba-4160-b797-f90ce5ebca88'
GROUP BY p.student, s.name;