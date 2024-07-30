# Distributed Consensus Simulation

This project simulates a distributed system where multiple nodes communicate with each other to achieve consensus on a shared state. It uses a simplified consensus mechanism instead of complex algorithms like Raft or Paxos. The simulation handles network partitions and node failures gracefully and logs state transitions and messages exchanged between nodes.

## Requirements

- Ruby (>= 2.5.0)

## Getting Started

### Installation

1. Clone the repository:
   ```sh
   git clone git@github.com:balerum03/simulation.git
   cd simulation
   ```

2. Ensure you have Ruby installed:
   ```sh
   ruby -v
   ```

3. (Optional) Install Bundler and use it to install dependencies:
   ```sh
   gem install bundler
   bundler install
   ```

### Running the Simulation

1. there is a section on the code with a comment line in the file `simulation.rb` with the following content:

   ```ruby
   node1 = Node.new(1)
   node2 = Node.new(2)
   node3 = Node.new(3)
   node1.add_neighbor(node2)
   node1.add_neighbor(node3)
   node2.add_neighbor(node1)
   node2.add_neighbor(node3)
   node3.add_neighbor(node1)
   node3.add_neighbor(node2)

   node1.propose_state(1)
   node2.propose_state(2)
   node3.simulate_partition([node1])
   node2.propose_state(3)

   puts "Node 1 log:"
   puts node1.retrieve_log
   puts "\nNode 2 log:"
   puts node2.retrieve_log
   puts "\nNode 3 log:"
   puts node3.retrieve_log
   ```

2. Run the simulation:
   ```sh
   ruby simulation.rb
   ```

### Changing the Test Samples

To modify the test scenarios, you can edit the `simulation.rb` file where the comment line is. Here is an example on how your tests can look like once modified:

- **Adding/Removing Nodes**: You can add more nodes or remove existing ones.
- **Proposing States**: Change the state values proposed by the nodes.
- **Simulating Network Partitions and Failures**: Use the `simulate_partition` and `simulate_recovery` methods to simulate network issues.

Example changes:
```ruby
# Adding a new node
node4 = Node.new(4)
node1.add_neighbor(node4)
node2.add_neighbor(node4)
node3.add_neighbor(node4)
node4.add_neighbor(node1)
node4.add_neighbor(node2)
node4.add_neighbor(node3)

# Proposing new states
node1.propose_state(10)
node2.propose_state(20)
node3.propose_state(5)
node4.propose_state(15)

# Simulating network partitions and recoveries
node3.simulate_partition([node1, node4])
node4.simulate_recovery([node1])
```

### Example Usage

The current example in `simulation.rb` demonstrates the following:

1. Three nodes (node1, node2, and node3) are created and added as neighbors to each other.
2. Nodes propose different states.
3. A network partition is simulated where node1 is isolated.
4. Logs of all nodes are printed to show the sequence of events and consensus reached.

Feel free to modify `simulation.rb` to test different scenarios and observe how the nodes reach consensus.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This README provides clear instructions on how to set up, run, and modify the simulation, making it easier for others to understand and use your project.
