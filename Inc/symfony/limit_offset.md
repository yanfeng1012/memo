## doctrine querybuilder limit and offset

	 $this->getEntityManager()
	      ->createQuery('...')
	      ->setMaxResults(5)
	      ->setFirstResult(10)
	      ->getResult();