SELECT 
  'EXECUTE sp_addrolemember ''' + roles.name + ''', ''' + users.name + ''''
FROM sys.database_principals users
  inner join sys.database_role_members link
   on link.member_principal_id = users.principal_id
  inner join sys.database_principals roles
   on roles.principal_id = link.role_principal_id
WHERE users.name='<<username>>';
