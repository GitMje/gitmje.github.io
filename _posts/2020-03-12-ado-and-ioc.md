---
layout:     post
title:      IoC and ADO.Net
date:       2020-03-12 10:00:00
author:     Michael Erpenbeck
summary:    IoC and ADO.Net
categories: C#
thumbnail:  jekyll
tags:
 - C#
---

I reviewed a coworker's code today and realized that the use of ADO.net and Inversion-of-Control is not commonly understood.  While the ADO.net team designed these Classes/Interfaces to be used in this way, even Microsoft's examples do not discuss this technique.

My coworker's code looked something like the following:
```csharp
    using (SqlConnection conn = new SqlConnection(myConnectionString))
    {
        SqlCommand exeCommand = new SqlCommand(exeSql, conn);
        conn.Open();
        exeCommand.ExecuteNonQuery();

        SqlCommand command = new SqlCommand(querySql, conn);
        ...
        SqlDataReader reader = command.ExecuteReader();
        ...
    }
```

I explained to him that when you peel back the `SqlCommand` class, you realize it inherits from `DbCommand` and implements `IDbCommand`.  I typically program to the `IDbCommand` interface rather than the concrete class.  Additionally, `SqlCommand` implements `IDisposable`.  This means that we can create tighter code for this.  
For example:
```csharp
    using (var cmd = conn.CreateCommand())
    { ... }
```

Additionally, it would be cleaner to inject the `IDbConnection` rather than new'ing up the `conn` as a concrete SqlConnection.  The cool thing here is that you can unit test and mock it much easier.

Even more importantly it means that you can also use configuration strings of different database types in the app.config you could use a PostgresSql, mySql, etc database and not lock yourself into `SqlConnection`, which is specific to SQL Server only.  I have done this before when I had hybrid db types that I needed to query.  I had a situation where I needed to do a foreach through a ton of different databases that were of different database types.

So for the app.config/web.config, you use the `providerName` parameter.
```xml
  <connectionStrings>
    <add name="MySqlServerDB" providerName="System.Data.SqlClient" connectionString="Server=REDACTED;Database=REDACTED;Trusted_Connection=True;" />
    <add name="MyPostgressDB" providerName="Npgsql" connectionString="Password=REDACTED;Server=REDACTED;Port=5432;Database=REDACTED;User Id=REDACTED;" />
    <add name="MyNetezzaDB" connectionString="Provider=NZOLEDB;Data Source=REDACTED;User ID=REDACTED;Password=REDACTED;Initial Catalog=System;Persist Security Info=True" providerName="System.Data.OleDb" />
  </connectionStrings>
```

For the `SqlDataReader`, you can do:
```csharp
    using (var cmd = conn.CreateCommand())
    {
        using (var reader = cmd.ExecuteReader())
        { ... }
    }
```

I suggested to my coworker to break both of these two commands into two separate resuable methods.  One of the things that you'll realize after you use this pattern 5+ times is that you typically use `ExecuteReaders` and `ExecuteNonQuery` methods.  Using the DRY principle, you will find that you only need to define one class to access the DB with a few simple methods.  If you are using the Repository design pattern, don't put the database access in each respoitory, you can just put it in one class.

Note, if you searched for how to do a sql query in C#, 9/10 examples will show it exactly how my coworker did it.  But these tricks make the code super flexible and testable.  Hopefully this helps out anyone that is looking for a way to have their code testable.