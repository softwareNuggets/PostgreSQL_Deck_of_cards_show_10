CREATE OR REPLACE FUNCTION populate_deck()
RETURNS void 
AS 
$$
DECLARE
    card_suit 	text[] := ARRAY['Clubs', 'Diamonds', 'Hearts', 'Spades'];
    rank_value 	text[] := ARRAY['Ace','King','Queen','Jack', '10', '9', '8', '7', '6', '5', '4', '3', '2'];
    card_value 	text;
	i			integer;
	j			integer;
BEGIN

	TRUNCATE deck;
	
    FOR i IN 1..4 LOOP
	
		FOR j IN 1..13 LOOP
		
	        card_value := rank_value[j] || ' ' || card_suit[i];
		
            INSERT INTO deck (card) 
			VALUES (card_value);
			
		END LOOP;
		
    END LOOP;
END;
$$ LANGUAGE plpgsql;






select * from populate_deck()
select * from deck