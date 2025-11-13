function Use-Queue {
    [CmdletBinding()]
    param()

    try {
        # Create a Queue
        $queue = [System.Collections.Queue]::new()

        # Enqueue items
        $queue.Enqueue("Task1")
        $queue.Enqueue("Task2")
        $queue.Enqueue("Task3")

        # Dequeue items until the queue is empty
        do {
            $item = $queue.Dequeue()
            Write-Output "Processing: $item"
        } while ($queue.Count -gt 0)
    }
    catch [System.Exception] {
        Write-Error "Error: $($_.Exception.Message)"
    }
}

if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    Use-Queue
}
