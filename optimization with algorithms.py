#dijkstra
import networkx as nx
import matplotlib.pyplot as plt


class Node:
    def __init__(self, name):
        self.name = name
        self.connections = {}
        self.distance = float('inf')
        self.previous = None


class RomaNetwork:
    def __init__(self):
        self.nodes = {}

    def add_link(self, from_node, to_node, distance):
        if from_node not in self.nodes:
            self.nodes[from_node] = Node(from_node)
        if to_node not in self.nodes:
            self.nodes[to_node] = Node(to_node)
        self.nodes[from_node].connections[to_node] = distance
        self.nodes[to_node].connections[from_node] = distance  # מוסיף קשר דו-כיווני


def find_optimal_route(network, start, end):
    start_node = network.nodes[start]
    start_node.distance = 0

    unprocessed = list(network.nodes.values())

    while unprocessed:
        current = min(unprocessed, key=lambda node: node.distance)
        unprocessed.remove(current)

        if current.name == end:
            break

        for neighbor, distance in current.connections.items():
            new_distance = current.distance + distance
            if new_distance < network.nodes[neighbor].distance:
                network.nodes[neighbor].distance = new_distance
                network.nodes[neighbor].previous = current

    path = []
    current = network.nodes[end]
    while current:
        path.append(current.name)
        current = current.previous

    return network.nodes[end].distance, list(reversed(path))


def visualize_network(network, route=None):
    G = nx.Graph()
    for node_name, node in network.nodes.items():
        G.add_node(node_name)
        for neighbor, distance in node.connections.items():
            G.add_edge(node_name, neighbor, weight=distance)

    pos = nx.spring_layout(G)
    plt.figure(figsize=(12, 8))
    nx.draw(G, pos, with_labels=True, node_color='lightblue', node_size=3000, font_size=10, font_weight='bold')

    edge_labels = nx.get_edge_attributes(G, 'weight')
    nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

    if route:
        path_edges = list(zip(route, route[1:]))
        nx.draw_networkx_edges(G, pos, edgelist=path_edges, edge_color='r', width=2)

    plt.title("Rome Attractions Map")
    plt.axis('off')
    plt.show()


# יצירת רשת של יעדים ברומא
roma = RomaNetwork()
roma.add_link("Colosseum", "Pantheon", 1.5)
roma.add_link("Colosseum", "Trevi Fountain", 2.0)
roma.add_link("Pantheon", "Trevi Fountain", 0.5)
roma.add_link("Pantheon", "Piazza Navona", 0.3)
roma.add_link("Trevi Fountain", "Piazza Navona", 0.7)
roma.add_link("Piazza Navona", "Vatican", 2.5)
roma.add_link("Trevi Fountain", "Vatican", 2.2)
roma.add_link("Colosseum", "Roman Forum", 0.5)
roma.add_link("Roman Forum", "Piazza Navona", 1.2)

# מקרא
locations = {
    "Colosseum": "קולוסיאום",
    "Pantheon": "פנתיאון",
    "Trevi Fountain": "מזרקת טרווי",
    "Piazza Navona": "פיאצה נבונה",
    "Roman Forum": "פורום רומאנו",
    "Vatican": "ואתיקן"
}

# בדיקת המסלול האופטימלי
start_point = "Colosseum"
end_point = "Vatican"
distance, route = find_optimal_route(roma, start_point, end_point)

print("מקרא:")
for key, value in locations.items():
    print(f"{key}: {value}")

print(f"\nהמסלול האופטימלי מ{locations[start_point]} ל{locations[end_point]}:")
print(f"מרחק כולל: {distance:.1f} ק\"מ")
print(f"מסלול: {' -> '.join([locations[node] for node in route])}")

# יצירת ויזואליזציה של הרשת והמסלול
visualize_network(roma, route)