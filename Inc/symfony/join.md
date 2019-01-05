## Doctrine join (连表查询)

> Doctrine\ORM\QueryBuilder::join(string $join, string $alias, string|null $conditionType=null, string|null $condition=null, string|null $indexBy=null) : QueryBuilder 
Creates and adds a join over an entity association to the query.

>The entities in the joined association will be fetched as part of the query result if the alias used for the joined association is placed in the select expressions.

	$qb = $em->createQueryBuilder() 
		->select('u') 
		->from('User', 'u') 
		->join('u.Phonenumbers', 'p', Expr\Join::WITH, 'p.is_primary = 1');

### Parameters:

#### string

	$join The relationship to join. 
	string $alias The alias of the join. 
	string|null $conditionType The condition type 		constant. Either ON or WITH. 
	string|null $condition The condition for the 		join. 
	string|null $indexBy The index for the join. 
		
### Returns:

QueryBuilder This QueryBuilder instance. 