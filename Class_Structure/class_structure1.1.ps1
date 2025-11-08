<#
Version where a property itself is another object

This reflects how PowerShell cmdlets (like Get-Process) return complex .NET objects —
many properties are objects themselves (e.g., StartInfo, Threads, etc.).
#>

# Define a helper class
class Engine {
    [string] $Type
    [int] $HorsePower

    Engine([string]$type, [int]$horsePower) {
        $this.Type = $type
        $this.HorsePower = $horsePower
    }

    [string] GetEngineInfo() {
        return "$($this.Type) engine with $($this.HorsePower) HP"
    }
}

# Define main class
class Car {
    [string] $Make
    [int] $Year
    [Engine] $Engine   # Property that is another object type

    Car([string]$make, [int]$year, [Engine]$engine) {
        $this.Make = $make
        $this.Year = $year
        $this.Engine = $engine
    }

    [string] GetInfo() {
        return "Car: $($this.Make), Year: $($this.Year), Engine: $($this.Engine.GetEngineInfo())"
    }
}

# Create an Engine object
$engine = [Engine]::new("V8", 450)

# Create a Car object with the Engine object as a property
$myCar = [Car]::new("Ford Mustang", 2020, $engine)

# Inspect types
$myCar.Engine.GetType().FullName  # System.Engine (custom class)
$myCar.Engine.HorsePower.GetType().FullName  # System.Int32

# Call method
$myCar.GetInfo()


