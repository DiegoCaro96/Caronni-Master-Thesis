/*Suppose that the univocity of the identifiers is already implemented in the db that provides the following tables*/
/////////////////////////* FACTS*///////////////////////
def accessModes(): #{ AccessMode(String,String) | r } = #{
     AccessMode("r", "Read").
     AccessMode("w", "Write").
     AccessMode("u", "Update").
     AccessMode("d", "Delete").
}

def operations(): #{ Operation(String,String) | r } = #{
    Operation("e", "Encrypt").
    Operation("d", "Decrypt").
}

def securityMeasures(): #{ SecurityMeasure(String, String, String) | r } = #{
    SecurityMeasure("www1", "alg123456", "bhj96" ).
    SecurityMeasure("www1", "alg123456", "yuigh").
    SecurityMeasure("www1", "alg2", "hj908").
}

def resources(): #{ Resource(String) | r } = #{
    Resource("www1").
    Resource("www2").
}

def metadataWithNumbers(): #{ Metadatan(String, String, Int32 , String) | r } = #{
    Metadatan("www1","Last update", 2018, " ").
    Metadatan("www1","Rank of sensitivity",2, " ").
    Metadatan("www2","Last update", 2015, " ").
    Metadatan("www2","Rank of sensitivity",5, " ").
}

def metadataWithLiterals(): #{ Metadatal(String, String, String, String) | r } = #{
    Metadatal("www1", "Company", "c1", " ").
    Metadatal("www2", "Company", "c2", " ").
    Metadatal("www1", "Format of the data", ".txt", " ").
    Metadatal("www2", "Format of the data", ".pdf", " ").
}

def agents(): #{ Agent(String) | r } = #{
    Agent("a2b67").
    Agent("98uio").
}

def agentAttributesWithNumbers(): #{ AgentAttributen(String, String, Int32, String) | r } = #{
    AgentAttributen("a2b67", "Years in the company", 1 , " ").
    AgentAttributen("a2b67", "Years of experience", 1 , " ").
    AgentAttributen("98uio", "Years in the company", 10 , " ").
    AgentAttributen("98uio", "Years of experience", 15 , " ").
}

def agentAttributesWithLiterals(): #{ AgentAttributel(String, String, String, String) | r } = #{
    AgentAttributel("a2b67", "Company", "c1", " ").
    AgentAttributel("a2b67", "Role", "doctor", " ").
    AgentAttributel("98uio", "Company", "c2", " ").
    AgentAttributel("98uio", "Role", "nurse", " ").
}

def searchSecMeasures(uri:String): #{SearchSecMeasure(String,String),SecurityMeasure(String,String,String)} =#{
    SearchSecMeasure(id,access_key) :- SecurityMeasure(uri,id,access_key).
}
///////////////////////*functions for literal metadata and attributes*//////////////
def searchbyformat(format: String): #{SearchByFormat(String),Metadatal(String,String,String,String)} =#{
    SearchByFormat(uri) :- Metadatal(uri,"Format of the data", format,_).
}

def searchAttributesLofAgent(id: String):#{ AttrLAgent(String,String),AgentAttributel(String, String, String, String)} =#{
    AttrLAgent(name,value) :- AgentAttributel(id,name,value,_). 
}

def searchMetadataLofResource(uri: String):#{ MetadataLResource(String,String),Metadatal(String, String, String, String)} =#{
    MetadataLResource(name,value) :- Metadatal(uri,name,value,_).
   
}

///////////////////////*functions for numerical metadata and attributes*//////////////
def searchAttributesNofAgent(id: String):#{ AttrNAgent(String,Int32),AgentAttributen(String, String, Int32, String)} =#{
    AttrNAgent(name,value) :- AgentAttributen(id,name,value,_).
   
}

def searchMetadataNofResource(uri: String):#{ MetadataNResource(String,Int32),Metadatan(String, String, Int32, String)} =#{
    MetadataNResource(name,value) :- Metadatan(uri,name,value,_).
}

def searchByYear(year: Int32): #{ResourceYear(String), Metadatan(String,String,Int32,String)}  =#{
    ResourceYear(uri) :- Metadatan(uri, "Last update",year,_).
}

def searchBeforeYear(year: Int32): #{ResourceBefore(String), Metadatan(String,String,Int32,String)}  =#{
    ResourceBefore(uri) :- Metadatan(uri, "Last update",y,_), if y <= year.
}

def searchAfterYear(year: Int32): #{ResourceAfter(String), Metadatan(String,String,Int32,String)}  =#{
    ResourceAfter(uri) :- Metadatan(uri, "Last update",y,_), if y >= year.
}

/////////////////////////*AUTHORIZATIONS*///////////////////////
def authorizations(): #{HaveOperation(String,String,String), Authorization(String,String,String), AccessMode(String,String), Resource(String), AgentAttributel(String,String,String,String), SameName(String,String,String,String), Metadatal(String, String, String, String),SeniorInCompany(String,String,String),SeniorWorker(String,String), AgentAttributen(String,String,Int32,String), Metadatan(String,String,Int32,String), SensitiveResources(String), Operation(String,String)} = #{
    /*CONSTRAINTS*/
    SensitiveResources(uri) :- Metadatan(uri, "Rank of sensitivity", value,_), if value >= 4.
    SameName(uri,id,name,value) :- Metadatal(uri,name,value,_), AgentAttributel(id,name,value,_).
    SeniorWorker(id,role) :-AgentAttributel(id,"Role",role,_), AgentAttributen(id, "Years of experience",experience,_),if experience >= 10.
    SeniorInCompany(id,role,company) :- AgentAttributel(id,"Company",company,_),AgentAttributel(id,"Role",role,_),AgentAttributen(id, "Years in the company",years,_),if years >= 5.
   
   /*AUTHORIZATIONS*/
   /*doctors*/
   /*doctors can read every resource, 
             can update resources provided by their company 
             can write resources provided by their company if they are experienced workers
             can delete resources provided by their company if they are experienced workers and also work for their company for some years*/
   Authorization(uri,id,access_mode) :- Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Read").
   Authorization(uri,id,access_mode) :- SameName(uri,id,"Company",_), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Update").
   Authorization(uri,id,access_mode) :- SeniorWorker(id,"doctor"),SameName(uri,id,"Company",_), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Write").
   Authorization(uri,id,access_mode) :- SeniorInCompany(id,_,_),SeniorWorker(id,_),SameName(uri,id,"Company",_), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Delete").

   /*nurses*/
   /*nurses  can read resourcess provided by their company 
             can update resources provided by their company if they are experienced workers
             can write resourcess provided by their company if they are experienced workers and also work for their company for some years*/
   Authorization(uri,id,access_mode) :- SameName(uri,id,"Company",_), Resource(uri), AgentAttributel(id,"Role","nurse",_), AccessMode(access_mode,"Read").
   Authorization(uri,id,access_mode) :- SeniorWorker(id,"nurse"),SameName(uri,id,"Company",_), Resource(uri), AgentAttributel(id,"Role","nurse",_), AccessMode(access_mode,"Update").
   Authorization(uri,id,access_mode) :- SeniorInCompany(id,_,_),SeniorWorker(id,_),SameName(uri,id,"Company",_), Resource(uri), AgentAttributel(id,"Role","nurse",_), AccessMode(access_mode,"Write"). 
   
   HaveOperation(uri,id,op) :- Authorization(uri,id, "r"), Operation(op,"Decrypt").
   HaveOperation(uri,id,op) :- Authorization(uri,id, "w"), Operation(op,"Encrypt"). 

}


/////////////////////////*AUTHORIZATIONS*///////////////////////

def main(): Unit \ IO =
query searchAttributesLofAgent("a2b67"), agentAttributesWithLiterals() select (x,y) from AttrLAgent(x,y) |> println;
query searchAttributesNofAgent("a2b67"), agentAttributesWithNumbers() select (x,y) from AttrNAgent(x,y) |> println;
query searchSecMeasures("www1"), securityMeasures() select (alg, access_key) from SearchSecMeasure(alg, access_key) |> println;
query searchByYear(2018), metadataWithNumbers() select (uri) from ResourceYear(uri) |> println;
query searchBeforeYear(2023), metadataWithNumbers() select (uri) from ResourceBefore(uri) |> println;
query authorizations(), metadataWithNumbers() select (x) from SensitiveResources(x) |> println;
query authorizations(), agentAttributesWithLiterals(), agentAttributesWithNumbers() select (id,role,company) from SeniorInCompany(id,role,company) |>println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers() select (uri,id,access_mode) from Authorization(uri, id, access_mode) |> println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers(),operations() select (uri,id,access_mode) from HaveOperation(uri, id, access_mode) |> println