CREATE OR REPLACE FUNCTION pick_random_cards(number_of_cards_requested integer)
RETURNS SETOF text 
AS $$
DECLARE 
    number_of_cards_in_the_deck integer;
    selected_cards 				text[] := '{}';
	selected_cards_temp 		varchar(20);
BEGIN
    -- how many cards are currently in the table called deck?
    SELECT COUNT(*) INTO number_of_cards_in_the_deck FROM deck;

    IF number_of_cards_requested > number_of_cards_in_the_deck THEN
        PERFORM populate_deck();
        SELECT COUNT(*) INTO number_of_cards_in_the_deck FROM deck;
    END IF;
    
    FOR i IN 1..number_of_cards_requested LOOP
		
        SELECT card INTO selected_cards_temp FROM (SELECT card FROM deck ORDER BY random() LIMIT 1) c;
		
        selected_cards := array_append(selected_cards, selected_cards_temp);
		
        DELETE FROM deck WHERE card = selected_cards_temp;
		
        number_of_cards_in_the_deck := number_of_cards_in_the_deck - 1;
		
    END LOOP;
    
    RETURN QUERY SELECT unnest(selected_cards);
END;
$$ LANGUAGE plpgsql;
