import random
from robot.api.deco import library, keyword

@library
class PulsePollKW():
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    @keyword
    def average_rate(self, summed, length):
        """ Laskee palautteiden keskiarvon\n
        Pythonin mahdollisen pyöristysvirheen korjaamiseksi palauttaa listan, jossa on keskiarvo ja keskiarvo + 0.01.\n
        """
        list = []
        averageRate = "{:.2f}".format(float(int(summed) / int(length)))
        list.append(averageRate)
        decimalRoundUp = "{:.2f}".format(float(averageRate) + 0.01)
        list.append(decimalRoundUp)
        return list
    
    @keyword
    def new_average_rate(self, summed, length, deletedValue):
        """ Laskee palautteiden keskiarvon yhden palautteen poiston jälkeen\n
        Pythonin mahdollisen pyöristysvirheen korjaamiseksi palauttaa listan, jossa on keskiarvo ja keskiarvo + 0.01.\n
        """
        list = []
        averageRate = "{:.2f}".format(float((int(summed) - int(deletedValue)) / (int(length) - 1)))
        list.append(averageRate)
        decimalRoundUp = "{:.2f}".format(float(averageRate) + 0.01)
        list.append(decimalRoundUp)
        return list



