# Define a class
class Car {
    [string] $Make          # String property
    [int] $Year             # Integer property
    [DateTime] $LastService # DateTime property

    # Constructor
    Car([string]$make, [int]$year, [DateTime]$lastService) {
        $this.Make = $make
        $this.Year = $year
        $this.LastService = $lastService
    }

    # Method
    [string] GetInfo() {
        return "Car: $($this.Make), Year: $($this.Year), Last Service: $($this.LastService)"
    }
}

# Create an object (instance of the class)
$myCar = [Car]::new("Toyota", 2018, (Get-Date "2025-01-15"))

# Access properties and their types
#Each property (Make, Year, LastService) has a different .NET type.
$myCar.Make.GetType().Name        # String
$myCar.Year.GetType().Name        # Int32
$myCar.LastService.GetType().Name # DateTime

# Call the method
$myCar.GetInfo()


<#
$mycar | Get-Member            

   TypeName: Car

Name        MemberType Definition
----        ---------- ----------
# these methods come from System.Object (.NET base class)
Equals      Method     bool Equals(System.Object obj)
GetHashCode Method     int GetHashCode()
GetType     Method     type GetType()
ToString    Method     string ToString()

# this method belongs to the Car class
GetInfo     Method     string GetInfo()

# these next three are properties defined inside the Car class
LastService Property   datetime LastService {get;set;}
Make        Property   string Make {get;set;}
Year        Property   int Year {get;set;}
#>

