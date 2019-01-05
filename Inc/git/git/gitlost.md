## 代码丢失找回方式（不保证一定能找回）

		
1. 首先**git fsck --lost-found**这个就是可以看下自己最近的一些删除的提交。 

	然后找到上述你刚才git stash drop stash@{0}时成功删除的id。例如： 
	Dropped stash@{0} (e2c07caec2b995ba75ce1abd15796c6f1686d532) 
	然后拷贝e2c07caec2b995ba75ce1abd15796c6f1686d532查找git fsck --lost-found列出的删除的提交id， 
	
2. 如果有恭喜你，离找回只差一步，你可以先用 
**git show e2c07caec2b995ba75ce1abd15796c6f1686d532**看一下是不是你丢弃的改动文件

3. 如果是，直接**git merge e2c07caec2b995ba75ce1abd15796c6f1686d532**即可找回！ 
