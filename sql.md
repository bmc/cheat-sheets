% SQL Cheat Sheet


Various SQL tricks and tips.

## Insert, but only if not there

To insert the values 'a' and 'b' into table `foo` (with columns named A, B),
but only where the values are not already there, try something like:

    INSERT INTO foo (  
      SELECT 'a' as A, 'b' as B FROM foo  
      WHERE A = 'a' AND B = 'b'  
      HAVING count(*)=0  
    )

