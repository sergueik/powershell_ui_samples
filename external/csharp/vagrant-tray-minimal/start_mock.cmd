start c:\java\selenium\hub.cmd
for /L %%. in (5000 1 5004 ) do start c:\java\selenium\node.cmd "localhost" %%. 
