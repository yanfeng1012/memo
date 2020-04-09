- cache result

		  return $this->createQueryBuilder('r')
		      ->select('r.name')
		      ->where('r.id IN(:ids)')
		      ->setParameter('ids', $ids, \Doctrine\DBAL\Connection::PARAM_INT_ARRAY)
		      ->getQuery()
		      ->useQueryCache(true)
		      ->useResultCache(true, 86400, 'custom_cache_id')
		      ->getArrayResult();
		  // inster or update delete cache
		  // to delete cache
		  $cacheDriver = $entityManager->getConfiguration()->getResultCacheImpl();
		  $cacheDriver->delete('my_custom_id');
		  // to delete all cache entries
	  	 $cacheDriver->deleteAll();