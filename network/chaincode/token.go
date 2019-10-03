package main

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"strings"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// docstrans type
type docstrans struct {
	docs string `json:"docs"`
	Name  string `json:"Name"`
	ID    string `json:"ID"`
}

func main() {

	err := shim.Start(new(docstrans))
	if err != nil {
		fmt.Println("Error with chaincode")
	} else {
		fmt.Println("Chaincode installed successfully")
	}
}

//Init docstrans  comment
func (t *docstrans) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("Initiate the chaincode")
	return shim.Success(nil)
}

//Invoke docstrans  comment
func (t *docstrans) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
	fmt.Println("Arguements ", fun)

	switch fun {
	case "Generatedocs":
		//create a new docs
		return t.Generatedocs(stub, args)
	case "sharedocs":
		return t.sharedocs(stub, args)
	case "GetAlldocs":
		return t.GetAlldocs(stub, args)
	case "QueryName":
		return t.QueryName(stub, args)

	}

	fmt.Println("Function not found!")
	return shim.Error("Recieved unknown function invocation!")
}

//Gendocs for
func Gendocs(Name string, ID string) string {

	//Generate docs for
	docsString := fmt.Sprintf("%s%s%s", Name, ID, time.Now().String())
	input := strings.NewReader(docsString)
	hash := sha256.New()
	if _, err := io.Copy(hash, input); err != nil {
		fmt.Println("Unable to Generate docs in Generatedocs: ", err)
		return string(err.Error())
	}

	return hex.EncodeToString(hash.Sum(nil))
}

//Generatedocs for user
func (t *docstrans) Generatedocs(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	var err error
	var docsobj docstrans

	if len(args) < 1 {
		fmt.Println("Invalid number of arguments")
		return shim.Error(err.Error())
	}

	err = json.Unmarshal([]byte(args[0]), &docsobj)
	//err = json.Unmarshal(&docsobj)

	if err != nil {
		fmt.Println("Unable to unmarshal data in Generatedocs : ", err)
		return shim.Error(err.Error())
	}
	docsobj.docs = Gendocs(docsobj.Name, docsobj.ID)

	JSONBytes1, err4 := json.Marshal(docsobj)
	if err4 != nil {
		fmt.Println("Unable to Marshal Generatedocs: ", err4)
		return shim.Error(err4.Error())
	}

	err = stub.PutState(docsobj.docs, JSONBytes1)
	// End - Put into Couch DB
	if err != nil {
		fmt.Println("Unable to make transaction for Generatedocs: ", err)
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

//sharedocs docs need to give name to share and docs generated 1- docs and sender name
func (t *docstrans) sharedocs(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	if len(args) < 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	//var docsobj docstrans

	docsBytes, _ := stub.GetState(args[0])
	docsobj := docstrans{}
	json.Unmarshal(docsBytes, &docsobj)
	docsobj.Name = args[1]

	docsBytes, _ = json.Marshal(docsobj)
	stub.PutState(args[0], docsBytes)

	return shim.Success(nil)
}

//GetAlldocs func
func (t *docstrans) GetAlldocs(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	queryString := fmt.Sprintf("{\"selector\":{\"docs\":{\"$ne\": \"%s\"}}}", "null")
	queryResults, err := getQueryResultForQueryString(stub, queryString)
	//fetch data from couch db ends here
	if err != nil {
		fmt.Printf("Unable to get All docs details: %s\n", err)
		return shim.Error(err.Error())
	}
	fmt.Printf("docs Details : %v\n", queryResults)

	return shim.Success(queryResults)
}

// getQueryResultForQueryString
func getQueryResultForQueryString(stub shim.ChaincodeStubInterface, queryString string) ([]byte, error) {

	fmt.Printf("***getQueryResultForQueryString queryString:\n%s\n", queryString)

	resultsIterator, err := stub.GetQueryResult(queryString)

	if err != nil {
		fmt.Println("Error from getQueryResultForQueryString:  ", err)
		return nil, err
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing QueryRecords
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("***getQueryResultForQueryString queryResult:\n%s\n", buffer.String())

	return buffer.Bytes(), nil
} // getQueryResultForQueryString

//QueryName comment
func (t *docstrans) QueryName(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	if len(args) < 1 {
		fmt.Println("Invalid number of arguments")
		return shim.Error(err.Error())
	}
	//fetch data from couch db starts here
	var Name = args[0]
	queryString := fmt.Sprintf("{\"selector\":{\"Name\":{\"$eq\": \"%s\"}}}", Name)
	queryResults, err := getQueryResultForQueryString(stub, queryString)
	//fetch data from couch db ends here
	if err != nil {
		fmt.Printf("Unable to get Node details: %s\n", err)
		return shim.Error(err.Error())
	}
	fmt.Printf("Details for name    : %v\n", queryResults)

	return shim.Success(queryResults)
}
