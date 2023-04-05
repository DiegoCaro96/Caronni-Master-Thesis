//Suppose that the univocity of the identifiers is already implemented in the db that provides the following tables//
///////////////////////// FACTS///////////////////////
def accessModes(): #{ AccessMode(String,String) | r } = #{
     AccessMode("r", "Read").
     AccessMode("w", "Write").
     AccessMode("u", "Update").
     AccessMode("d", "Delete").
}

def operations(): #{ Operation(String,String) | r } = #{
    Operation("encr", "Encrypt").
    Operation("decr", "Decrypt").
    /*probably there will be other operations*/
}

/*(uri of the resource, algorithm, access key)*/
def securityMeasures(): #{ SecurityMeasure(String, String, String) | r } = #{
    SecurityMeasure("www1", "alg123456", "bhj96" ).
    SecurityMeasure("www1", "alg123456", "yuigh").
    SecurityMeasure("www1", "alg2", "hj908").
}

/*(uri)*/
def resources(): #{ Resource(String) | r } = #{
    Resource("www1").
    Resource("www2").
}

/*(uri, name, value, description)*/
def metadataWithNumbers(): #{ Metadatan(String, String, Int32 , String) | r } = #{
    Metadatan("www1","Last modified", 2018, " ").
    Metadatan("www2","Last modified", 2015, " ").
}

/*(uri, name, value, description)*/
def metadataWithLiterals(): #{ Metadatal(String, String, String, String) | r } = #{
    Metadatal("www1", "Company", "c1", " ").
    Metadatal("www2", "Company", "c2", " ").
    Metadatal("www1", "Format of the data", ".txt", " ").
    Metadatal("www2", "Format of the data", ".pdf", " ").
    Metadatal("www1", "Type of data", "public", " "). /*public,private*/ 
    Metadatal("www2", "Type of data", "private", " ").
    Metadatal("www1", "Source", "sensor", " "). /*sensor,person*/
    Metadatal("www2", "Source", "person", " ").
    Metadatal("www1", "Original URI Source", "wwwN", " "). /*Original uri of the source*/
    Metadatal("www1", "Consent", "y", " "). /*Consent: yes/no*/
    Metadatal("www2", "Consent", "y", " ").
}

/*(id)*/
def agents(): #{ Agent(String) | r } = #{
    Agent("a2b67").
    Agent("98uio").
}

/*(id, name, value, description)*/
def agentAttributesWithNumbers(): #{ AgentAttributen(String, String, Int32, String) | r } = #{
    AgentAttributen("a2b67", "Years in the company", 1 , " ").
    AgentAttributen("a2b67", "Years of experience", 1 , " ").
    AgentAttributen("98uio", "Years in the company", 10 , " ").
    AgentAttributen("98uio", "Years of experience", 15 , " ").
}

/*(id, name, value, description)*/
def agentAttributesWithLiterals(): #{ AgentAttributel(String, String, String, String) | r } = #{
    AgentAttributel("a2b67", "Company", "c1", " ").
    AgentAttributel("a2b67", "Role", "doctor", " ").
    AgentAttributel("98uio", "Company", "c2", " ").
    AgentAttributel("98uio", "Role", "nurse", " ").
}

///////////////////////////FUNCTIONS//////////////////////////////
/*RESOURCES*/
/*function to find all security measures associated to a given resource passed in input*/
def searchSecMeasures(uri:String): #{SearchSecMeasure(String,String),SecurityMeasure(String,String,String)} =#{
    SearchSecMeasure(algorithm,access_key) :- SecurityMeasure(uri,algorithm,access_key).
}

/*function to map the relation RESOURCE - HAVE - SECURITY MEASURES*/
def havesecuritymeasures(): #{HaveSecMeasure(String), Resource(String),SecurityMeasure(String,String,String)} =#{
    HaveSecMeasure(uri) :- Resource(uri), SecurityMeasure(uri,_,_).
}

/*search all the literal metadata associated to the Resource received in input*/
def searchMetadataLofResource(uri: String):#{ MetadataLResource(String,String),Metadatal(String, String, String, String)} =#{
    MetadataLResource(name,value) :- Metadatal(uri,name,value,_). 
}

/*function to map the relation RESOURCE - HAVE - METADATA*/
def haveliteralmetadata(): #{HaveLitMetadata(String), Resource(String),Metadatal(String,String,String,String)} =#{
    HaveLitMetadata(uri) :- Resource(uri), Metadatal(uri,_,_,_).
}

/*search all the literal metadata associated to the Resource received in input*/
def searchMetadataNofResource(uri: String):#{ MetadataNResource(String,Int32),Metadatan(String, String, Int32, String)} =#{
    MetadataNResource(name,value) :- Metadatan(uri,name,value,_).
}

/*function to map the relation RESOURCE - HAVE - METADATA*/
def havenumericalmetadata(): #{HaveNumMetadata(String), Resource(String),Metadatan(String,String,Int32,String)} =#{
    HaveNumMetadata(uri) :- Resource(uri), Metadatan(uri,_,_,_).
}

/*search resources according to Last modified*/
def searchByYear(year: Int32): #{ResourceYear(String), Metadatan(String,String,Int32,String)}  =#{
    ResourceYear(uri) :- Metadatan(uri, "Last modified",year,_).
}

def searchBeforeYear(year: Int32): #{ResourceBefore(String), Metadatan(String,String,Int32,String)}  =#{
    ResourceBefore(uri) :- Metadatan(uri, "Last modified",y,_), if y <= year.
}

def searchAfterYear(year: Int32): #{ResourceAfter(String), Metadatan(String,String,Int32,String)}  =#{
    ResourceAfter(uri) :- Metadatan(uri, "Last modified",y,_), if y >= year.
}

/*find all resources provided by a company*/
def searchAllOfCompany(company: String): #{SearchAllOfCompany(String),Metadatal(String,String,String,String)} =#{
    SearchAllOfCompany(uri) :- Metadatal(uri,"Company", company,_).
}

/*search resources by format*/
def searchbyformat(format: String): #{SearchByFormat(String),Metadatal(String,String,String,String)} =#{
    SearchByFormat(uri) :- Metadatal(uri,"Format of the data", format,_).
}

/*find public or private resource put in input private or public*/
def searchByType(typee: String): #{SearchByType(String),Metadatal(String,String,String,String)} =#{
    SearchByType(uri) :- Metadatal(uri,"Type of data", typee,_).
}

/*search resources provided by sensor or person*/
def searchBySource(source: String): #{SearchBySource(String),Metadatal(String,String,String,String)} =#{
    SearchBySource(uri) :- Metadatal(uri,"Source", source,_).
}

def findOriginalUri(uri: String): #{OriginalUri(String),Metadatal(String,String,String,String)} =#{
    OriginalUri(uri_source) :- Metadatal(uri,"Original URI Source", uri_source,_).
}


/*AGENTS*/
/*search all literal attributes of the agent given in input*/
def searchAttributesLofAgent(id: String):#{ AttrLAgent(String,String),AgentAttributel(String, String, String, String)} =#{
    AttrLAgent(name,value) :- AgentAttributel(id,name,value,_). 
}

/*function to map the relation AGENT - HAVE - ATTRIBUTES*/
def haveliteralattributes(): #{HaveLitAttributes(String),Agent(String), AgentAttributel(String, String, String, String)} =#{ 
    HaveLitAttributes(id) :- Agent(id),AgentAttributel(id,_,_,_).
}

/*search all numerical attributes of the agent given in input*/
def searchAttributesNofAgent(id: String):#{ AttrNAgent(String,Int32),AgentAttributen(String, String, Int32, String)} =#{
    AttrNAgent(name,value) :- AgentAttributen(id,name,value,_).  
}

/*function to map the relation AGENT - HAVE - ATTRIBUTES*/
def havenumericalattributes(): #{HaveNumAttributes(String),Agent(String), AgentAttributen(String, String, Int32, String)} =#{ 
    HaveNumAttributes(id) :- Agent(id),AgentAttributen(id,_,_,_).
}

/*find all workers of a company*/
def allworkers(company:String): #{AllWorkers(String,String), AgentAttributel(String,String,String,String)} =#{
    AllWorkers(id,role) :- AgentAttributel(id,"Company",company,_),AgentAttributel(id,"Role",role,_).
}

/////////////////////////*AUTHORIZATIONS*///////////////////////
def authorizations(): #{ HaveOperation(String,String), 
                         HaveAccessMode(String,String),
                         AuthWithSameUriId(String,String),
                         OpWithSameUriId(String,String),
                         AssignOperation(String,String,String), 
                         Authorization(String,String,String), 
                         LessPowerfull(String,String),
                         MorePowerfull(String,String),
                         SameName(String,String,String,String), 
                         SeniorInCompany(String,String,String),
                         SeniorWorker(String,String),
                         SensitiveResource(String), 
                         RecentResource(String),
                         ConsentResource(String), 
                         /*facts*/
                         AccessMode(String,String), 
                         Operation(String,String),
                         Resource(String), 
                         Metadatal(String, String, String, String),
                         Metadatan(String,String,Int32,String),
                         AgentAttributel(String,String,String,String),  
                         AgentAttributen(String,String,Int32,String)} =                    
#{
    /*POSSIBLE FILTERS TO MAKE AUTHORIZATIONS*/
    /*on metadata*/
    SensitiveResource(uri) :- Metadatal(uri, "Type of data", value,_), if value == "private".
    RecentResource(uri) :- Metadatan(uri, "Last modified",year,_), if year >= 2020.
    ConsentResource(uri) :- Metadatal(uri, "Consent", value,_), if value == "y".
    /*on attributes*/
    SameName(uri,id,name,value) :- Metadatal(uri,name,value,_), AgentAttributel(id,name,value,_). /*AGENT AND RESOURCE THAT HAVE SAME LITERAL ATTRIBUTE AND METADATA WITH THE SAME VALUE EXAMPLE: BELONG TO THE SAME COMPANY*/
    SeniorWorker(id,role) :-AgentAttributel(id,"Role",role,_), AgentAttributen(id, "Years of experience",experience,_),if experience >= 10.
    SeniorInCompany(id,role,company) :- AgentAttributel(id,"Company",company,_),AgentAttributel(id,"Role",role,_),AgentAttributen(id, "Years in the company",years,_),if years >= 5.
   
   /*AUTHORIZATIONS*/  /* read and write less restrictive than update and delete*/
   /*doctors*/
   /*doctors -- consent resources
             can read every resource, 
             can write resources provided by their company 
             can update resources provided by their company if they are experienced workers
             can delete resources provided by their company if they are experienced workers and also work for their company for some years*/
   Authorization(uri,id,access_mode) :- ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Read").
   Authorization(uri,id,access_mode) :- SameName(uri,id,"Company",_),ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Write").
   Authorization(uri,id,access_mode) :- SeniorWorker(id,"doctor"),SameName(uri,id,"Company",_),ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Update").
   Authorization(uri,id,access_mode) :- SeniorInCompany(id,_,_),SeniorWorker(id,_),SameName(uri,id,"Company",_),ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","doctor",_), AccessMode(access_mode,"Delete").

   /*nurses*/
   /*nurses -- consent resources and public 
             can read resources provided by their company 
             can write resources provided by their company if they are experienced workers
             can update resourcess provided by their company if they are experienced workers and also work for their company for some years*/
   Authorization(uri,id,access_mode) :- SameName(uri,id,"Company",_), not SensitiveResource(uri), ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","nurse",_), AccessMode(access_mode,"Read").
   Authorization(uri,id,access_mode) :- SeniorWorker(id,"nurse"),SameName(uri,id,"Company",_),not SensitiveResource(uri), ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","nurse",_), AccessMode(access_mode,"Write").
   Authorization(uri,id,access_mode) :- SeniorInCompany(id,_,_),SeniorWorker(id,_),SameName(uri,id,"Company",_),not SensitiveResource(uri), ConsentResource(uri), Resource(uri), AgentAttributel(id,"Role","nurse",_), AccessMode(access_mode,"Update"). 

   /*classify authorizations*/
   LessPowerfull(uri,id) :- Authorization(uri,id,am), if am == "r".
   LessPowerfull(uri,id) :- Authorization(uri,id,am), if am == "w".
   MorePowerfull(uri,id) :- Authorization(uri,id,am), if am == "u".
   MorePowerfull(uri,id) :- Authorization(uri,id,am), if am == "d".

   /*find resources and their access modes, map the relation RESOURCE-HAVE-ACCESS MODE*/
   HaveAccessMode(uri,access_mode) :- Resource(uri), Authorization(uri,_,access_mode).

   /*authorizations with same uri e id*/
   AuthWithSameUriId(uri,id) :- Authorization(uri,id,access_mode1),Authorization(uri,id,access_mode2), if access_mode1 != access_mode2.

   /*if read or write it is possible only to decrypt, if update or delete it is possible to decrypt e encrypt*/
   AssignOperation(uri,id,op) :- Authorization(uri,id, "r"), Operation(op,"Decrypt").
   AssignOperation(uri,id,op) :- Authorization(uri,id, "w"), Operation(op,"Decrypt").
   AssignOperation(uri,id,op) :- Authorization(uri,id, "u"), Operation(op,"Decrypt").
   AssignOperation(uri,id,op) :- Authorization(uri,id, "u"), Operation(op,"Encrypt").
   AssignOperation(uri,id,op) :- Authorization(uri,id, "d"), Operation(op,"Decrypt"). 
   AssignOperation(uri,id,op) :- Authorization(uri,id, "d"), Operation(op,"Encrypt"). 

   /*find resources and their operation, map the relation RESOURCE-HAVE-OPERATION*/
   HaveOperation(uri,op) :- Resource(uri), AssignOperation(uri,_,op).

   /*authorizations with same uri e id*/
   OpWithSameUriId(uri,id) :- AssignOperation(uri,id,op1),AssignOperation(uri,id,op2), if op1 != op2.
}


/////////////////////////*MAIN*///////////////////////

def main(): Unit \ IO =
query searchMetadataNofResource("www2"), metadataWithNumbers() select (name,value) from MetadataNResource(name,value) |> println;
query searchSecMeasures("www1"), securityMeasures() select (alg, access_key) from SearchSecMeasure(alg, access_key) |> println;
query searchByYear(2018), metadataWithNumbers() select (uri) from ResourceYear(uri) |> println;
query searchAttributesLofAgent("a2b67"), agentAttributesWithLiterals() select (name,value) from AttrLAgent(name,value) |> println;
query searchAllOfCompany("c1"), metadataWithLiterals() select (uri) from SearchAllOfCompany(uri) |> println;
query allworkers("c2"), agentAttributesWithLiterals() select (id,role) from AllWorkers(id,role) |> println;
query findOriginalUri("www1"), metadataWithLiterals() select (uri_source) from OriginalUri(uri_source) |> println;
query findOriginalUri("www2"), metadataWithLiterals() select (uri_source) from OriginalUri(uri_source) |> println;

query authorizations(), metadataWithLiterals() select (x) from SensitiveResource(x) |> println;
query authorizations(), metadataWithLiterals() select (x) from ConsentResource(x) |> println;

query authorizations(), agentAttributesWithLiterals(), agentAttributesWithNumbers() select (id,role) from SeniorWorker(id,role) |>println;
query authorizations(), agentAttributesWithLiterals(), agentAttributesWithNumbers() select (id,role,company) from SeniorInCompany(id,role,company) |>println;

query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers() select (uri,id,access_mode) from Authorization(uri, id, access_mode) |> println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers() select (uri,id) from LessPowerfull(uri, id) |> println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers() select (uri,id) from MorePowerfull(uri, id) |> println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers() select (uri,id) from AuthWithSameUriId(uri, id) |> println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers(),operations() select (uri,id,op) from AssignOperation(uri, id, op) |> println


/*others
query searchBeforeYear(2023), metadataWithNumbers() select (uri) from ResourceBefore(uri) |> println;
query searchAttributesNofAgent("98uio"), agentAttributesWithNumbers() select (name,value) from AttrNAgent(name,value) |> println;

query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers() select (uri,access_mode) from HaveAccessMode(uri,access_mode) |> println;
query authorizations(),resources(),agentAttributesWithLiterals(), accessModes(), metadataWithLiterals(), agentAttributesWithNumbers(),operations() select (uri,op) from HaveOperation(uri, op) |> println;
*/