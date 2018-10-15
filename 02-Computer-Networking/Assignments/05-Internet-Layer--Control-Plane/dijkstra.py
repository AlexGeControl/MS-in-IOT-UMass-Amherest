#!/usr/bin/python
import heapq
from collections import namedtuple

class PQ(object):
    def __init__(self):
        self._pq = []

    def get_elements(self):
        return self._pq

    def push(self, key, value):
        heapq.heappush(self._pq, (key, value))
    
    def pop(self):
        (key, value) = heapq.heappop(self._pq)

        return (key, value)

Hop = namedtuple('Hop', ['current', 'previous'])

def get_link_state_routing(network, init):
    """
    use link-state algorithm to compute the forward table for selected router n
    """
    from sets import Set

    # total number of routers:
    N = len(network)

    # states:
    explored = Set()
    frontier = PQ()
    routes = {}
    table = []

    # init:
    init_hop = Hop(current = init, previous = init)
    frontier.push(0, init_hop)

    while len(explored) < N:
        # explore:
        cost, hop = frontier.pop()

        # filter: 
        current = hop.current
        if current in explored:
            continue

        # update:
        explored.add(current)
        routes[current] = {
            'cost': cost,
            'parent': hop.previous
        }

        # expand frontier:
        for next_hop, link_cost in network[current].iteritems():
            if not next_hop in explored:
                frontier.push(
                    cost + link_cost, 
                    Hop(current = next_hop, previous = current)
                )

        # get current state
        status = {}
        for router in network.keys():
            if router in explored:
                status[router] = (routes[router]['cost'], routes[router]['parent'])
            else:
                status[router] = next(
                    ((r[0], r[1].previous) for r in frontier.get_elements() if r[1].current == router), 
                    (None, None)
                )
        table.append(
            ",".join(sorted(explored)) + "--" + "\t".join(str((router, status[router])) for router in sorted(network.keys()))
        ) 

    # format table:
    table = "\n".join(table)
    # format routes:
    for terminal, state in routes.iteritems():
        route = [terminal]

        parent = state['parent']
        while routes[parent]['parent'] != parent:
            route.append(parent)
            parent = routes[parent]['parent']
        route.append(parent)

    return table, routes

if __name__ == '__main__':
    # network topology definition:
    network = {
        't': {
            'u': 2, 'v': 4, 'y': 7
        },
        'u': {
            't': 2, 'v': 3, 'w': 3
        },
        'v': {
            't': 4, 'u': 3, 'w': 4, 'x': 3, 'y': 8
        },
        'w': {
            'u': 3, 'v': 4, 'x': 6
        },
        'x': {
            'v': 3, 'w': 6, 'y': 6, 'z': 8
        },
        'y': {
            't': 7, 'v': 8, 'x': 6, 'z': 12
        },
        'z': {
            'x': 8, 'y': 12
        }
    }

    table, route = get_link_state_routing(network, 'x')

    print table