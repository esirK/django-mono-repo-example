import django

from src.helpers import connect_to_twitter

def adder(x, y):
    from src import utils
    return utils.sum(x, y)

if __name__ == '__main__':
    # print(os.environ)
    print(django.VERSION)
    print(adder(1, 2))
    connect_to_twitter()
    import sys
    print(sys.version)
