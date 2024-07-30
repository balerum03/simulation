require 'thread'

class Node
  attr_reader :node_id, :log, :state

  def initialize(node_id)
    @node_id = node_id
    @neighbors = []
    @log = []
    @state = nil
    @proposed_state = nil
    @leader_id = nil
    @simulated_failure = false
    @lock = Mutex.new
  end

  def add_neighbor(neighbor)
    @neighbors << neighbor
  end

  def send_message(neighbor, message)
    return if @simulated_failure

    neighbor.receive_message(self, message)
    log_message("Sent #{message} to Node #{neighbor.node_id}")
  end

  def receive_message(sender, message)
    return if @simulated_failure

    log_message("Received #{message} from Node #{sender.node_id}")
    handle_message(sender, message)
  end

  def handle_message(sender, message)
    case message[:type]
    when :propose_state
      handle_propose_state(sender, message[:state])
    when :accept_state
      handle_accept_state(sender, message[:state])
    end
  end

  def handle_propose_state(sender, state)
    if @proposed_state.nil? || state > @proposed_state
      @lock.synchronize do
        if @proposed_state.nil? || state > @proposed_state
          @proposed_state = state
          @leader_id = sender.node_id
          log_message("Node #{@node_id} accepted proposed state #{state} from Node #{sender.node_id}")
        end
      end
      broadcast_message(type: :accept_state, state: @proposed_state)
    end
  end

  def handle_accept_state(sender, state)
    @lock.synchronize do
      @state = state
      log_message("Node #{@node_id} accepted new state #{state} from Node #{sender.node_id}")
    end
  end

  def broadcast_message(message)
    @neighbors.each do |neighbor|
      send_message(neighbor, message)
    end
  end

  def log_message(message)
    @log << message
  end

  def retrieve_log
    @log
  end

  def propose_state(state)
    @lock.synchronize do
      @proposed_state = state
      log_message("Node #{@node_id} proposed state #{state}")
    end
    broadcast_message(type: :propose_state, state: state)
  end

  def simulate_partition(nodes)
    nodes.each { |node| node.simulated_failure = true }
  end

  def simulate_recovery(nodes)
    nodes.each { |node| node.simulated_failure = false }
  end

  protected

  attr_writer :simulated_failure
end

# the lines below represent an example usage for the program, to test further feel free to change the lines below as you wish

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
