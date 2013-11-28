def LRU(seq):
    hit = miss = 0
    cache = []
    for ch in seq:
        if ch in cache:
            hit += 1
            cache.remove(ch)
            cache.append(ch)
        else:
            miss += 1
            if len(cache) == 4:
                cache.pop(0)
            cache.append(ch)
    print hit, miss

def MRU(seq):
    hit = miss = 0
    cache = []
    for ch in seq:
        if ch in cache:
            hit += 1
            cache.remove(ch)
            cache.append(ch)
        else:
            miss += 1
            if len(cache) == 4:
                cache.pop(len(cache)-1)
            cache.append(ch)
    print hit, miss

def CLOCK(seq):
    hit = miss = 0
    cache = ['%','%','%','%']
    i = 0
    
    for ch in seq:
        if ch in cache:
            hit += 1
        else:
            miss += 1
            cache[i] = ch
            i = (i + 1) % 4
    print hit, miss

def try_all(seq):
    LRU(seq)
    MRU(seq)
    CLOCK(seq)
#try_all('ABCDAFADGDGEDF')
try_all('BEARSBEARSBEARSBEARS')
try_all('BEARSEARSEARSEARS')
try_all('GOBEARSGOBEARSGOBEARS')
