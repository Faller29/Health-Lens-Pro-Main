import 'package:flutter/material.dart';

final Map<String, Map<String, Map<String, int>>> itemMacronutrients = {
  'Chicken (Adobong Iga)': {
    //check
    //Warning lang na kapag sobra sa oil yung luto bawal dito (hyper, obesity, diabetes)
    'Whole Cup': {
      'fats': 6,
      'carbs': 3,
      'proteins': 16,
      'warnings': 4,
    },
    'Half Cup': {
      'fats': 3,
      'carbs': 2,
      'proteins': 8,
      'warnings': 4,
    },
  },
  'Chicken (Chicken Inasal)': {
    //check
    'Breast': {'fats': 11, 'carbs': 0, 'proteins': 34},
    'Leg': {'fats': 9, 'carbs': 0, 'proteins': 24},
  },
  'Chicken (Fried Chicken)': {
    //check
    'Drumstick': {
      'fats': 7,
      'carbs': 0,
      'proteins': 14,
      'warnings': 2,
    },
    'Breast': {
      'fats': 18,
      'carbs': 0,
      'proteins': 62,
      'warnings': 2,
    },
    'Leg': {
      'fats': 17,
      'carbs': 0,
      'proteins': 31,
      'warnings': 2,
    },
    'Thigh': {
      'fats': 10,
      'carbs': 0,
      'proteins': 17,
      'warnings': 2,
    },
    'Wing': {
      'fats': 7,
      'carbs': 0,
      'proteins': 9,
      'warnings': 2,
    },
  },
  'Fish (Daing na Bangus)': {
    //check
    'Slice': {'fats': 5, 'carbs': 13, 'proteins': 0},
  },
  'Fish (Pan Fried Tilapia)': {
    //check
    'Head': {'fats': 2, 'carbs': 1, 'proteins': 3},
    'Body': {'fats': 7, 'carbs': 4, 'proteins': 10},
    'Tail': {'fats': 2, 'carbs': 1, 'proteins': 3},
  },
  'Fish (Sinaing na Tulingan)': {
    //check
    'Head': {'fats': 3, 'carbs': 4, 'proteins': 0},
    'Body': {'fats': 10, 'carbs': 11, 'proteins': 1},
    'Tail': {'fats': 3, 'carbs': 4, 'proteins': 0},
  },
  'Pork (Breaded Pork Chop)': {
    //1 slice ng tenderloin
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper, obesity, diabetes)
    'Pork Chop': {
      'fats': 22,
      'carbs': 22,
      'proteins': 26,
      'warnings': 4,
    },
  },
  'Pork (Lechon Kawali)': {
    //1 cup cooked, diced
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper, obesity, diabetes)
    'Whole Cup': {
      'fats': 37,
      'carbs': 4,
      'proteins': 25,
      'warnings': 4,
    },
    'Half Cup': {
      'fats': 19,
      'carbs': 2,
      'proteins': 13,
      'warnings': 4,
    },
  },
  'Pork (Pork Bistek)': {
    //1 slice ng tenderloin
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper, obesity, diabetes)
    'Pork Chop': {'fats': 22, 'carbs': 10, 'proteins': 79},
  },
  'Boiled Egg': {
    //check
    'Whole Egg': {'fats': 5, 'carbs': 1, 'proteins': 6},
    'Half Egg': {'fats': 3, 'carbs': 0, 'proteins': 3},
  },
  'Scrambled Egg': {
    //check
    'Chicken Egg': {'fats': 7, 'carbs': 1, 'proteins': 6},
  },
  'Sunny Side Up Egg': {
    //check
    'Chicken Egg': {'fats': 7, 'carbs': 0, 'proteins': 6},
  },
  'White Rice (Boiled Rice)': {
    //check
    'Whole Cup': {'fats': 0, 'carbs': 45, 'proteins': 4},
    'Half Cup': {'fats': 0, 'carbs': 23, 'proteins': 2},
  },
  'White Rice (Fried Rice)': {
    //check
    'Whole Cup': {'fats': 4, 'carbs': 45, 'proteins': 6},
    'Half Cup': {'fats': 2, 'carbs': 23, 'proteins': 3},
  },
  'Bread': {
    //check (1 piece)
    'Pandesal': {
      'fats': 5,
      'carbs': 23,
      'proteins': 6,
    },
    'Ensaymada': {
      //check (1 piece)
      'fats': 17,
      'carbs': 20,
      'proteins': 4,
      'warnings': 3,
    },
  },
};
