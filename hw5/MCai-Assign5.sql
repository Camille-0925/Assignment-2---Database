1.
SELECT itemDescription, quantityOnHand
FROM item
WHERE itemDescription LIKE '%antibiotic%';

2.
SELECT volunteerName
FROM volunteer
WHERE volunteerTelephone NOT LIKE '2%' AND volunteerName NOT LIKE '% Jones';

3.
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
JOIN task ON assignment.taskCode = task.taskCode
JOIN task_type ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName = 'transporting';

4.
SELECT task.taskDescription
FROM task
WHERE task.taskCode NOT IN(
    SELECT assignment.taskCode
    FROM assignment
);

5.
SELECT package_type.packageTypeName
FROM package_type
JOIN package ON package_type.packageTypeId = package.packageTypeId
JOIN package_contents ON package.packageId = package_contents.packageId
JOIN item ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%bottle%'
GROUP BY package_type.packageTypeName;

6.
SELECT item.itemDescription
FROM item
WHERE item.itemId NOT IN (
    SELECT package_contents.itemId
    FROM package_contents);

7.
SELECT task.taskDescription
FROM task
JOIN assignment ON task.taskCode = assignment.taskCode
JOIN volunteer ON assignment.volunteerId = volunteer.volunteerId
WHERE volunteer.volunteerAddress LIKE '%NJ'
GROUP BY task.taskCode;

8.
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
WHERE assignment.startDateTime BETWEEN '2021-01-01' AND '2021-06-30 23:59:59';

9.
SELECT volunteer.volunteerName
FROM volunteer
JOIN assignment ON volunteer.volunteerId = assignment.volunteerId
JOIN package ON assignment.taskCode = package.taskCode
JOIN package_contents ON package.packageId = package_contents.packageId
JOIN item ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%spam%'
GROUP BY volunteer.volunteerId;

10.
SELECT item.itemDescription
FROM item
JOIN package_contents ON item.itemId = package_contents.itemId
WHERE item.itemValue * package_contents.itemQuantity = 100;

11.
SELECT task_status.taskStatusName, COUNT(DISTINCT assignment.volunteerId) AS volunteers
FROM assignment
JOIN task ON assignment.taskCode = task.taskCode
JOIN task_status ON task.taskStatusId = task_status.taskStatusId
GROUP BY task_status.taskStatusName
ORDER BY volunteers DESC;

12.
SELECT package.taskCode, SUM(package.packageWeight) AS totalWeight
FROM package
GROUP BY package.taskCode
ORDER BY totalWeight DESC
LIMIT 1;

13.
SELECT COUNT(task.taskCode) AS nonPackingTasks
FROM task
JOIN task_type ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName != 'packing';

14.
SELECT item.itemDescription
FROM item
JOIN package_contents ON item.itemId = package_contents.itemId
JOIN package ON package_contents.packageId = package.packageId
JOIN assignment ON package.taskCode = assignment.taskCode
GROUP BY item.itemId
HAVING COUNT(DISTINCT assignment.volunteerId) < 3;

15.
SELECT package_contents.packageId,
       SUM(item.itemValue * package_contents.itemQuantity) AS packageValue
FROM package_contents
JOIN item ON package_contents.itemId = item.itemId
GROUP BY package_contents.packageId
HAVING packageValue > 100
ORDER BY packageValue ASC;







