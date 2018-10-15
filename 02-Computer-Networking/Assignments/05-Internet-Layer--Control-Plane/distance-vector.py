#!/usr/bin/python
def get_distance_vector_routes(network):
    # set up session:
    import copy
    from pprint import pprint

    # init:
    dv_prev = copy.deepcopy(network)
    for router in dv_prev.keys():
        dv_prev[router][router] = 0
        dv_prev[router] = {
            k: (v, k) for k,v in dv_prev[router].iteritems()
        }
    dv_next = copy.deepcopy(dv_prev)
    should_broadcast = {}
    for router in dv_prev.keys():
        should_broadcast[router] = True

    while any(should_broadcast.values()):
        # compute:
        for router in network.keys():
            for neighbor in network[router].keys():
                for dest, route in dv_prev[neighbor].iteritems():
                    (cost, _) = route
                    # propose new route cost:
                    new_route = (network[router][neighbor] + cost, neighbor)
                    # keep only min:
                    if dest in dv_next[router]:
                        dv_next[router][dest] = min(dv_next[router][dest], new_route, key = lambda t: t[0])
                    else:
                        dv_next[router][dest] = new_route
            # should broadcast current route table:
            should_broadcast[router] = (dv_next[router] != dv_prev[router])
        
        # save current state:
        dv_prev = copy.deepcopy(dv_next)

        # display:
        pprint(dv_next)
        pprint(should_broadcast)

        print ""

if __name__ == '__main__':
    # network topology definition:
    network = {
        'u': {
            'v': 1, 'y': 2
        },
        'v': {
            'u': 1, 'x': 3, 'z': 6
        },
        'x': {
            'v': 3, 'y': 3, 'z': 2
        },
        'y': {
            'u': 2, 'x': 3
        },
        'z': {
            'v': 6, 'x': 2
        }
    }

    get_distance_vector_routes(network)