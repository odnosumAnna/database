-- ¬иб≥рка вс≥х ƒ“ѕ, де к≥льк≥сть постраждалих б≥льше 2 ≥ тип ƒ“ѕ Ц "Rear-end"
SELECT * 
FROM Accident
WHERE Victim_Count > 2 AND Accident_Type = 'Rear-end';

-- ¬иб≥рка вс≥х ƒ“ѕ, де або к≥льк≥сть постраждалих б≥льше 5, або тип ƒ“ѕ Ц "Head-on"
SELECT * 
FROM Accident
WHERE Victim_Count > 5 OR Accident_Type = 'Head-on';

-- ¬иб≥рка вс≥х ƒ“ѕ, де тип ƒ“ѕ не Ї "Rear-end"
SELECT * 
FROM Accident
WHERE NOT Accident_Type = 'Rear-end';

-- ¬иб≥рка вс≥х ƒ“ѕ, де к≥льк≥сть постраждалих не менша за 5
SELECT * 
FROM Accident
WHERE Victim_Count >= 5;

-- ¬иб≥рка вс≥х ƒ“ѕ, де дата сталас€ до 2021 року
SELECT * 
FROM Accident
WHERE Date < '2021-01-01';

-- ¬иб≥рка вс≥х ƒ“ѕ, де к≥льк≥сть постраждалих не дор≥внюЇ 0
SELECT * 
FROM Accident
WHERE Victim_Count <> 0;

-- ¬иб≥рка вс≥х ƒ“ѕ п≥сл€ 2020 року, де б≥льше н≥ж 3 постраждалих ≥ тип не "Side-swipe"
SELECT * 
FROM Accident
WHERE Date > '2020-12-31' AND Victim_Count > 3 AND NOT Accident_Type = 'Side-swipe';
