import 'package:flutter/material.dart';

final Map<String, Map<String, Map<String, int>>> itemMacronutrients = {
  'Boiled Ampalaya': {
    //check
    '1 Cup': {'fats': 4, 'carbs': 5, 'proteins': 1},
    '1/2 Cup': {'fats': 2, 'carbs': 3, 'proteins': 1},
    '1/4 of Cup': {'fats': 1, 'carbs': 1, 'proteins': 0},
  },
  'Boiled Broccoli': {
    //check
    '1 Cup': {'fats': 0, 'carbs': 4, 'proteins': 2},
    '1/2 Cup': {'fats': 0, 'carbs': 2, 'proteins': 1},
    '1/4 of Cup': {'fats': 0, 'carbs': 1, 'proteins': 1},
  },
  'Boiled Carrot': {
    //check
    '1 Cup': {'fats': 0, 'carbs': 13, 'proteins': 1},
    '1/2 Cup': {'fats': 0, 'carbs': 7, 'proteins': 1},
    '1/4 of Cup': {'fats': 0, 'carbs': 3, 'proteins': 0},
  },
  'Boiled Corn': {
    //check
    '1 Small': {'fats': 1, 'carbs': 19, 'proteins': 3}, //(5-6 inches long)
    '1 Medium': {'fats': 2, 'carbs': 22, 'proteins': 4}, //(7 inches long)
    '1 Large': {'fats': 2, 'carbs': 25, 'proteins': 4}, //(8-9 inches long)
    '1 Cup': {'fats': 2, 'carbs': 31, 'proteins': 5},
    '1/2 Cup': {'fats': 1, 'carbs': 16, 'proteins': 3},
    '1/4 of Cup': {'fats': 1, 'carbs': 8, 'proteins': 1},
  },
  'Boiled Egg': {
    //check
    'Whole Egg': {'fats': 5, 'carbs': 1, 'proteins': 6},
    'Half Egg': {'fats': 3, 'carbs': 0, 'proteins': 3},
  },
  'Boiled Eggplant': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 9,
      'proteins': 1
    }, //(1 inch per pieces in the cup)
    '1/2 Cup': {'fats': 0, 'carbs': 5, 'proteins': 1},
    '1/4 of Cup': {'fats': 0, 'carbs': 2, 'proteins': 0},
  },
  'Boiled Kalabasa': {
    //check
    '1 Cup': {'fats': 1, 'carbs': 5, 'proteins': 2},
    '1/2 Cup': {'fats': 1, 'carbs': 3, 'proteins': 1},
    '1/4 of Cup': {'fats': 0, 'carbs': 1, 'proteins': 1},
  },
  'Boiled Kangkong': {
    //check
    '1 Cup': {'fats': 0, 'carbs': 12, 'proteins': 4},
    '1/2 Cup': {'fats': 0, 'carbs': 6, 'proteins': 2},
    '1/4 of Cup': {'fats': 0, 'carbs': 3, 'proteins': 1},
  },
  'Boiled Mushroom': {
    //check
    '1 Cup': {'fats': 1, 'carbs': 8, 'proteins': 3},
    '1/2 Cup': {'fats': 0, 'carbs': 4, 'proteins': 2},
    '1/4 of Cup': {'fats': 0, 'carbs': 2, 'proteins': 1},
  },
  'Boiled Okra': {
    //check
    '1 Cup': {'fats': 4, 'carbs': 10, 'proteins': 4},
    '1/2 Cup': {'fats': 2, 'carbs': 5, 'proteins': 2},
    '1/4 of Cup': {'fats': 1, 'carbs': 3, 'proteins': 1},
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
  'Chicken (Adobong Iga)': {
    //check
    //Case 1: Warning lang na kapag sobra sa oil nung luto bawal dito (hyper, obesity, diabetes)
    //Case 2: Warning if matamis yung luto bawal sa may diabetes
    'Whole Cup': {
      'fats': 16,
      'carbs': 8,
      'proteins': 16,
    },
    'Half Cup': {
      'fats': 8,
      'carbs': 4,
      'proteins': 8,
    },
  },
  'Chicken (Chicken Inasal)': {
    //check
    'Breast with Wings': {'fats': 27, 'carbs': 13, 'proteins': 27},
    'Leg': {'fats': 21, 'carbs': 13, 'proteins': 24},
    'Thigh': {'fats': 10, 'carbs': 5, 'proteins': 20},
    'Drumstick': {'fats': 13, 'carbs': 7, 'proteins': 27},
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
      'fats': 9,
      'carbs': 0,
      'proteins': 31,
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
    'Big - 1 Slice': {'fats': 12, 'carbs': 1, 'proteins': 22},
    'Small - 1 Slice': {'fats': 5, 'carbs': 0, 'proteins': 13},
  },
  'Fish (Pan Fried Tilapia)': {
    //check
    'Head': {'fats': 3, 'carbs': 6, 'proteins': 8},
    'Body': {'fats': 10, 'carbs': 17, 'proteins': 25},
    'Tail': {'fats': 3, 'carbs': 6, 'proteins': 8},
  },
  'Fish (Sinaing na Tulingan)': {
    //check
    'Head': {'fats': 4, 'carbs': 0, 'proteins': 7},
    'Body': {'fats': 13, 'carbs': 1, 'proteins': 22},
    'Tail': {'fats': 4, 'carbs': 0, 'proteins': 7},
  },
  'Kamatis': {
    //check
    '1 Cup, Diced': {'fats': 0, 'carbs': 16, 'proteins': 4},
    '1/2 Cup, Diced': {'fats': 0, 'carbs': 8, 'proteins': 2},
    '1/4 of Cup, Diced': {'fats': 0, 'carbs': 4, 'proteins': 1},
  },
  'Onion': {
    //check
    '1 Cup, Diced': {'fats': 0, 'carbs': 16, 'proteins': 1},
    '1/2 Cup, Diced': {'fats': 0, 'carbs': 8, 'proteins': 1},
    '1/4 of Cup, Diced': {'fats': 0, 'carbs': 4, 'proteins': 0},
  },
  'Pipino': {
    //check
    '1 Cup': {'fats': 0, 'carbs': 4, 'proteins': 0},
    '1/2 Cup': {'fats': 0, 'carbs': 2, 'proteins': 0},
    '1/4 of Cup': {'fats': 0, 'carbs': 1, 'proteins': 0},
  },
  'Pork (Breaded Pork Chop)': {
    //1 slice ng tenderloin
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper, obesity, diabetes)
    '1 Slice': {
      'fats': 26,
      'carbs': 19,
      'proteins': 30,
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
    'Pork Chop': {'fats': 7, 'carbs': 3, 'proteins': 26},
  },
  'Potato': {
    //check
    '1 Cup, Diced': {'fats': 0, 'carbs': 26, 'proteins': 3},
    '1/2 Cup, Diced': {'fats': 0, 'carbs': 13, 'proteins': 2},
    '1/4 of Cup, Diced': {'fats': 0, 'carbs': 7, 'proteins': 1},
  },
  'Scrambled Egg': {
    //check
    'Chicken Egg': {'fats': 7, 'carbs': 1, 'proteins': 6},
  },
  'Sunny Side Up Egg': {
    //check
    'Chicken Egg': {'fats': 7, 'carbs': 0, 'proteins': 6},
  },
  'Talbos ng Kamote (Boiled)': {
    //check
    '1 Cup': {'fats': 0, 'carbs': 2, 'proteins': 1},
    '1/2 Cup': {'fats': 0, 'carbs': 1, 'proteins': 1},
  },
  'Tortang Talong': {
    //check
    '1 Eggplant': {'fats': 13, 'carbs': 13, 'proteins': 9},
  },
  'White Rice (Fried Rice)': {
    //check
    'Whole Cup': {'fats': 4, 'carbs': 45, 'proteins': 6},
    'Half Cup': {'fats': 2, 'carbs': 23, 'proteins': 3},
  },
  'White Rice (Boiled Rice)': {
    //check
    'Whole Cup': {'fats': 0, 'carbs': 45, 'proteins': 4},
    'Half Cup': {'fats': 0, 'carbs': 23, 'proteins': 2},
  },
};
