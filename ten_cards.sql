--tested to work with postgreSQL 14

--1) create table
--2) add populate_deck() to postgresql
--3) add pick_random_cards() to postgresql
--
--to play
--select * from pick_random_cards()
--
-- to see the full deck of cards, or what is left 
--select * from deck

--to start the game over
--truncate table deck




--drop table deck
create table deck
(
	id int not null primary key,
	card varchar(20) not null
)


CREATE OR REPLACE FUNCTION populate_deck()
RETURNS void 
AS 
$$
DECLARE
    card_suits text[] := ARRAY['hearts', 'diamonds', 'clubs', 'spades'];
    card_ranks text[] := ARRAY['ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king'];
    card_value text;
	card_index integer := 1;
BEGIN

    FOR i IN 1..4 LOOP
	
		for j IN 1..13 loop
	        card_value := card_ranks[j] || ' ' || card_suits[i];
		
            INSERT INTO deck (id, card) 
			VALUES (card_index, card_value);
			
			RAISE NOTICE 'card_index=%, card_value=%', card_index, card_value;
			card_index := card_index + 1;
			
		end loop;
    END LOOP;
END;
$$ LANGUAGE plpgsql;







CREATE OR REPLACE FUNCTION pick_random_cards()
RETURNS SETOF text AS $$
DECLARE
    num_cards integer;
    selected_cards text[] := '{}';
	selected_cards_temp varchar(20);
    random_index integer;
BEGIN
    SELECT COUNT(*) INTO num_cards FROM deck;
    
    IF num_cards < 10 THEN
        TRUNCATE deck;
        PERFORM populate_deck();
        SELECT COUNT(*) INTO num_cards FROM deck;
    END IF;
    
    FOR i IN 1..10 LOOP
        random_index := (random() * num_cards)::integer % num_cards + 1;
        SELECT card INTO selected_cards_temp FROM (SELECT card FROM deck ORDER BY random() LIMIT 1) c;
        selected_cards := array_append(selected_cards, selected_cards_temp);
        DELETE FROM deck WHERE card = selected_cards_temp;
        num_cards := num_cards - 1;
    END LOOP;
    
    RETURN QUERY SELECT unnest(selected_cards);
END;
$$ LANGUAGE plpgsql;




