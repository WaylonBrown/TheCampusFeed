import csv

class Utility(object):
    def __init__(self):
        pass
    @staticmethod
    def write_dict_to_file(dict, file_name):
        writer = csv.writer(open(file_name, 'wb'))
        for key, value in dict.items():
            writer.writerow([key, value])