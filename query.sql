/*                  QUERY CON SELECT                  */

/* 1. Selezionare tutti gli studenti nati nel 1990 (160) */

SELECT * 
FROM `students`
WHERE YEAR(`date_of_birth`) = 1990;

/*------------------------------------------------------------------------------*/


/* 2. Selezionare tutti i corsi che valgono più di 10 crediti (479) */

SELECT *
FROM `courses`
WHERE `cfu` > 10;

/*------------------------------------------------------------------------------*/


/* 3. Selezionare tutti gli studenti che hanno più di 30 anni */

SELECT *
FROM `students`
WHERE DATEDIFF(CURDATE(), `date_of_birth`) / 365.25 > 30;
/*
DATEDIFF(`data1`, `data2`) restituisce la differenza tra due date in giorni
CURDATE() restituisce la data attuale
In questo modo stiamo eseguendo la differenza tra la data attuale e la data della colonna date_of_birth. Il risultato verrà diviso per 365.25 così da ottenere gli anni
filtrerà poi i record se l'età risulta essere maggiore di 30
*/

/*------------------------------------------------------------------------------*/


/* 4. Seleziona tutti i corsi del primo semestre del primo anno di qualsiasi corso di laurea (286) */

SELECT *
FROM `courses`
WHERE `year` = 1 AND `period` LIKE 'I s%';

/*------------------------------------------------------------------------------*/


/* 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21) */

SELECT *
FROM `exams`
WHERE HOUR(`hour`) >= 14 AND `date` = '2020-06-20';

/*------------------------------------------------------------------------------*/


/* 6. Selezionare tutti i corsi di laurea magistrale (38)  */
SELECT * 
FROM `degrees`
WHERE `level` = 'magistrale';

/*------------------------------------------------------------------------------*/


/* 7. Da quanti dipartimenti è composta l'università? (12) */

SELECT COUNT('id') as 'Numero_Dipartimenti'
FROM `departments`;

/*------------------------------------------------------------------------------*/


/* 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50) */

SELECT *
FROM `teachers`
WHERE `phone` IS NULL;

/*------------------------------------------------------------------------------*/


/*                  QUERY CON GROUPBY                  */

/* 1. Contare quanti iscritti ci sono stati ogni anno */

SELECT COUNT('id') as 'ISCRITTI_OGNI_ANNO', YEAR(`enrolment_date`)
FROM `students`
GROUP BY YEAR(`enrolment_date`);

/*------------------------------------------------------------------------------*/


/* 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio */

SELECT COUNT('id') as 'INSEGNANTI_NELLO_STESSO_UFFICIO', `office_address`
FROM `teachers`
GROUP BY `office_address`;

/*------------------------------------------------------------------------------*/


/* 3. Calcolare la media dei voti di ogni appello d'esame */

SELECT `exam_id`, AVG(`vote`)
FROM `exam_student`
GROUP BY `exam_id`;

/* se si vuole arrotondare il voto: */

/*
SELECT `exam_id`, ROUND(AVG(`vote`))
FROM `exam_student`
GROUP BY `exam_id`;
*/

/*------------------------------------------------------------------------------*/


/* 4. Contare quanti corsi di laurea ci sono per ogni dipartimento */

SELECT `department_id`, COUNT(`name`)
FROM `degrees`
GROUP BY `department_id`;

/*------------------------------------------------------------------------------*/


/*                  QUERY CON JOIN                  */


/* 1. Seleziona tutti gli studenti iscritti al Corso di Laurea in Economia */

SELECT *
FROM `students`
JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
WHERE `degrees`.`name` = "Corso di Laurea in Economia";

/*------------------------------------------------------------------------------*/


/* 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze */

SELECT * 
FROM `degrees`
JOIN `departments`
ON `degrees`.`department_id` = `departments`.`id`
WHERE `degrees`.`level` = "magistrale"
AND `departments`.`name` = "Dipartimento di Neuroscienze";

/*------------------------------------------------------------------------------*/


/* 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44) */

SELECT *
FROM `courses`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
WHERE `teachers`.`name` = "Fulvio" AND `teachers`.`surname` = "Amato"
OR `teachers`.`id` = 44;

/* Il controllo OR non era necessario ma abbiamo una sicurezza in più in caso dovessero esserci problemi relativi al nome */


/*------------------------------------------------------------------------------*/


/* 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome */

SELECT *
FROM `students`
JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
JOIN `departments`
ON `degrees`.`department_id` = `departments`.`id`
ORDER BY `students`.`surname`ASC, `students`.`name` ASC;

/*------------------------------------------------------------------------------*/


/* 5. Seleziona tutti i corsi di laurea con i relativi corsi e insegnanti */

SELECT *
FROM `degrees`
JOIN `courses`
ON `degrees`.`id` = `courses`.`degree_id`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`;

/*------------------------------------------------------------------------------*/


/* 6. Selezionare tutti i docenti che insegnano nel dipartimento di Matematica (54) */


SELECT `teachers`.`id`, `teachers`.`name`, `teachers`.`surname`, `departments`.`name`
FROM `teachers`
JOIN `course_teacher`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
JOIN `courses`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `degrees`
ON `courses`.`degree_id` = `degrees`.`id`
JOIN `departments`
ON `degrees`.`department_id` = `departments`.`id`
WHERE `departments`.`name` = "Dipartimento di Matematica";


