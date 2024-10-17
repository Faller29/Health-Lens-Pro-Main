import 'package:flutter/material.dart';

/* 

vegetables : 1
meat : 2
milk : 3
sugar : 4
fruit : 5
rice : 6
fat : 7


 */

final Map<String, Map<String, Map<String, dynamic>>> itemMacronutrients = {
  'Almonds': {
    '7 pieces': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
  },
  'Apple (Green)': {
    '1 piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
    '1/2 piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 5,
    },
  },
  'Apple (Red)': {
    '1 piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
    '1/2 piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 5,
    },
  },
  'Avocado': {
    '1 piece': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
    '1/2 piece': {
      'fats': 3,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 7,
    },
  },
  'Bacon': {
    '1 Strip/Piece': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
  },
  'Banana Chips': {
    '2 pcs': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Boiled Ampalaya': {
    //check
    '1 Cup': {
      'fats': 4,
      'carbs': 5,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 2,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Boiled Broccoli': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 4,
      'proteins': 2,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Boiled Carrot': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 13,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 0,
      'carbs': 7,
      'proteins': 1,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Boiled Corn': {
    //check
    '1 Small': {
      'fats': 1,
      'carbs': 19,
      'proteins': 3,
      'foodExchange': 1,
      'type': 1,
    }, //(5-6 inches long)
    '1 Medium': {
      'fats': 2,
      'carbs': 22,
      'proteins': 4,
      'foodExchange': 1,
      'type': 1,
    }, //(7 inches long)
    '1 Large': {
      'fats': 2,
      'carbs': 25,
      'proteins': 4,
      'foodExchange': 1,
      'type': 1,
    }, //(8-9 inches long)
    '1 Cup': {
      'fats': 2,
      'carbs': 31,
      'proteins': 5,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 1,
      'carbs': 16,
      'proteins': 3,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Boiled Egg': {
    //check
    'Whole Egg': {
      'fats': 5,
      'carbs': 1,
      'proteins': 6,
      'foodExchange': 1,
      'type': 2,
    },
    'Half Egg': {
      'fats': 3,
      'carbs': 0,
      'proteins': 3,
      'foodExchange': 0.5,
      'type': 2,
    },
  },
  'Boiled Eggplant': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 9,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    }, //(1 inch per pieces in the cup)
    '1/2 Cup': {
      'fats': 0,
      'carbs': 5,
      'proteins': 1,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Boiled Kalabasa': {
    //check
    '1 Cup': {
      'fats': 1,
      'carbs': 5,
      'proteins': 2,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 1,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Boiled Kangkong': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 12,
      'proteins': 4,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 0,
      'carbs': 6,
      'proteins': 2,
      'foodExchange': .5,
      'type': 1,
    },
  },
  'Boiled Mushroom': {
    //check
    '1 Cup': {
      'fats': 1,
      'carbs': 8,
      'proteins': 3,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 0,
      'carbs': 4,
      'proteins': 2,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Boiled Okra': {
    //check
    '1 Cup': {
      'fats': 4,
      'carbs': 10,
      'proteins': 4,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup': {
      'fats': 2,
      'carbs': 5,
      'proteins': 2,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Bread': {
    //check (1 piece)
    'Pandesal': {
      'fats': 5,
      'carbs': 23,
      'proteins': 6,
      'foodExchange': 1,
      'type': 6,
    },
    'Ensaymada': {
      //check (1 piece)
      'fats': 17,
      'carbs': 20,
      'proteins': 4,
      'warnings': 3,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Candy': {
    '1 Pieces': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Cashew Nut': {
    '6 Pieces': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
    '3 Pieces': {
      'fats': 3,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 7,
    },
  },
  'Chewing Gum': {
    '1 pc': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Chicken (Adobong Iga)': {
    //check
    //Case 1: Warning lang na kapag sobra sa oil nung luto bawal dito (hyper obesity, diabetes)
    //Case 2: Warning if matamis yung luto bawal sa may diabetes
    'Whole Cup': {
      'fats': 16,
      'carbs': 8,
      'proteins': 16,
      'foodExchange': 1,
      'type': 8,
    },
    'Half Cup': {
      'fats': 8,
      'carbs': 4,
      'proteins': 8,
      'foodExchange': 0.5,
      'type': 8,
    },
  },
  'Chicken (Chicken Inasal)': {
    //check
    'Breast with Wings': {
      'fats': 27,
      'carbs': 13,
      'proteins': 27,
      'foodExchange': 1,
      'type': 8,
    },
    'Leg': {
      'fats': 21,
      'carbs': 13,
      'proteins': 24,
      'foodExchange': 1,
      'type': 8,
    },
    'Thigh': {
      'fats': 10,
      'carbs': 5,
      'proteins': 20,
      'foodExchange': 1,
      'type': 8,
    },
    'Drumstick': {
      'fats': 13,
      'carbs': 7,
      'proteins': 17,
      'foodExchange': 1,
      'type': 8,
    },
  },
  'Chicken (Fried Chicken)': {
    //check
    'Drumstick': {
      'fats': 7,
      'carbs': 0,
      'proteins': 14,
      'warnings': 2,
      'foodExchange': 1,
      'type': 8,
    },
    'Breast': {
      'fats': 9,
      'carbs': 0,
      'proteins': 31,
      'warnings': 2,
      'foodExchange': 1,
      'type': 8,
    },
    'Leg': {
      'fats': 17,
      'carbs': 0,
      'proteins': 31,
      'warnings': 2,
      'foodExchange': 1,
      'type': 8,
    },
    'Thigh': {
      'fats': 10,
      'carbs': 0,
      'proteins': 17,
      'warnings': 2,
      'foodExchange': 1,
      'type': 8,
    },
    'Wing': {
      'fats': 7,
      'carbs': 0,
      'proteins': 9,
      'warnings': 2,
      'foodExchange': 1,
      'type': 8,
    },
  },
  'Chocolate': {
    '2 pcs': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Fish (Daing na Bangus)': {
    //check
    'Big - 1 Slice': {
      'fats': 12,
      'carbs': 1,
      'proteins': 22,
      'foodExchange': 1,
      'type': 8,
    },
    'Small - 1 Slice': {
      'fats': 5,
      'carbs': 0,
      'proteins': 13,
      'foodExchange': 0.5,
      'type': 8,
    },
  },
  'Fish (Pan Fried Tilapia)': {
    //check
    'Head': {
      'fats': 3,
      'carbs': 6,
      'proteins': 8,
      'foodExchange': 1,
      'type': 8,
    },
    'Body': {
      'fats': 10,
      'carbs': 17,
      'proteins': 25,
      'foodExchange': 1,
      'type': 8,
    },
    'Tail': {
      'fats': 3,
      'carbs': 6,
      'proteins': 8,
      'foodExchange': 1,
      'type': 8,
    },
  },
  'Fish (Sinaing na Tulingan)': {
    //check
    'Head': {
      'fats': 4,
      'carbs': 0,
      'proteins': 7,
      'foodExchange': 1,
      'type': 8,
    },
    'Body': {
      'fats': 13,
      'carbs': 1,
      'proteins': 22,
      'foodExchange': 1,
      'type': 8,
    },
    'Tail': {
      'fats': 4,
      'carbs': 0,
      'proteins': 7,
      'foodExchange': 1,
      'type': 8,
    },
  },
  'Honey': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Jam': {
    '2 Teaspoons': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Kamatis': {
    //check
    '1 Cup Diced': {
      'fats': 0,
      'carbs': 16,
      'proteins': 4,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup Diced': {
      'fats': 0,
      'carbs': 8,
      'proteins': 2,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Kiwifruit (Green)': {
    '1 piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
    '1/2 piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 5,
    },
  },
  'Low Fat Milk': {
    'Whole Cup': {
      'fats': 5,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 3,
      'carbs': 6,
      'proteins': 4,
      'foodExchange': 0.5,
      'type': 3,
    },
  },
  'Mango': {
    '1 cup': {
      'fats': 0,
      'carbs': 20,
      'proteins': 0,
      'foodExchange': 1.5,
      'type': 5,
    },
    '1/2 cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Marshmallow': {
    '3 pcs': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Mayonnaise': {
    '1 Teaspoon': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
  },
  'Nata de coco': {
    '1 Tablespoon': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Onion': {
    //check
    '1 Cup Diced': {
      'fats': 0,
      'carbs': 16,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup Diced': {
      'fats': 0,
      'carbs': 8,
      'proteins': 1,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Orange': {
    '1 piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
    '1/2 piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 5,
    },
  },
  'Papaya': {
    '1 piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
    '1/2 piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 5,
    },
  },
  'Peanut Butter': {
    '1 Tablespoon': {
      'fats': 10,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1.5,
      'type': 7,
    },
  },
  'Pipino': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 4,
      'proteins': 0,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Pork (Breaded Pork Chop)': {
    //1 slice ng tenderloin
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper obesity, diabetes)
    '1 Slice': {
      'fats': 26,
      'carbs': 19,
      'proteins': 30,
      'warnings': 4,
      'foodExchange': 1,
      'type': 8,
    },
  },
  'Pork (Lechon Kawali)': {
    //1 cup cooked diced
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper obesity, diabetes)
    'Whole Cup': {
      'fats': 37,
      'carbs': 4,
      'proteins': 25,
      'warnings': 4,
      'foodExchange': 1,
      'type': 8,
    },
    'Half Cup': {
      'fats': 19,
      'carbs': 2,
      'proteins': 13,
      'warnings': 4,
      'foodExchange': 0.5,
      'type': 8,
    },
  },
  'Pork (Pork Bistek)': {
    //1 slice ng tenderloin
    //Warning lang na iwasan yung matatabang part (para sa lahat ng sakit toh hyper obesity, diabetes)
    'Pork Chop': {
      'fats': 7,
      'carbs': 3,
      'proteins': 26,
      'foodExchange': 1,
      'type': 8,
    },
  },
  'Pork Crackling (Skin)': {
    '5 Pcs': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
    '3 Pcs': {
      'fats': 3,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 7,
    },
  },
  'Potato': {
    //check
    '1 Cup Diced': {
      'fats': 0,
      'carbs': 26,
      'proteins': 3,
      'foodExchange': 1,
      'type': 1,
    },
    '1/2 Cup Diced': {
      'fats': 0,
      'carbs': 13,
      'proteins': 2,
      'foodExchange': 0.5,
      'type': 1,
    },
  },
  'Raisins': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Salad Dressing': {
    '2 Teaspoons': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
    '1 Teaspoon': {
      'fats': 3,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 7,
    },
  },
  'Sandwich Spread': {
    '1 Tablespoon': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
  },
  'Scrambled Egg': {
    //check
    'Chicken Egg': {
      'fats': 7,
      'carbs': 1,
      'proteins': 6,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Skim Milk (Non-fat)': {
    'Whole Cup': {
      'fats': 0,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 0,
      'carbs': 6,
      'proteins': 4,
      'foodExchange': 0.5,
      'type': 3,
    },
  },
  'Sugar Apple': {
    '1 piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
    '1/2 piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 0.5,
      'type': 5,
    },
  },
  'Sunflower (Seeds)': {
    '1 Tablespoon': {
      'fats': 5,
      'carbs': 0,
      'proteins': 0,
      'foodExchange': 1,
      'type': 7,
    },
  },
  'Sunny Side Up Egg': {
    //check
    'Chicken Egg': {
      'fats': 7,
      'carbs': 0,
      'proteins': 6,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Syrup (Sugar)': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 7,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Talbos ng Kamote (Boiled)': {
    //check
    '1 Cup': {
      'fats': 0,
      'carbs': 2,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Tortang Talong': {
    //check
    '1 Eggplant': {
      'fats': 13,
      'carbs': 13,
      'proteins': 9,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Watermelon': {
    '1 slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'White Rice (Fried Rice)': {
    //check
    'Whole Cup': {
      'fats': 4,
      'carbs': 45,
      'proteins': 6,
      'foodExchange': 1,
      'type': 6,
    },
    'Half Cup': {
      'fats': 2,
      'carbs': 23,
      'proteins': 3,
      'foodExchange': 0.5,
      'type': 6,
    },
  },
  'White Rice (Boiled Rice)': {
    //check
    'Whole Cup': {
      'fats': 0,
      'carbs': 45,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
    'Half Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 0.5,
      'type': 6,
    },
  },
  'Whole Milk (Cow)': {
    'Whole Cup': {
      'fats': 10,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 5,
      'carbs': 6,
      'proteins': 4,
      'foodExchange': 0.5,
      'type': 3,
    },
  },
  'Whole Milk (Evaporated)': {
    '1 Cup': {
      'fats': 20,
      'carbs': 24,
      'proteins': 16,
      'foodExchange': 1.5,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 10,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },
  'Whole Milk (Goat)': {
    'Whole Cup': {
      'fats': 10,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 5,
      'carbs': 6,
      'proteins': 4,
      'foodExchange': 0.5,
      'type': 3,
    },
  },
  'Yogurt': {
    '1 Cup': {
      'fats': 10,
      'carbs': 24,
      'proteins': 16,
      'foodExchange': 1.5,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 5,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },
  'Yogurt (Non-fat)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 25,
      'proteins': 16,
      'foodExchange': 1.5,
      'type': 3,
    },
    '1/2 Cup': {
      'fats': 0,
      'carbs': 12,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },

//New Additions (Need To Be Arranged Alphabetically)
  'Beef': {
    '1 Slice of Shank': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Lean Meat': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Round': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Tenderloin': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Porterhouse Steak': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Sirloin': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Flank': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Plate': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Chuck/Lean': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Brisket': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Carabeef': {
    '1 Slice of Shank': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice Lean Meat with Little Fat': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Round': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Lean Meat with Medium Fat': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Chuck': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Round Steak': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Rump': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Goat/Chevon': {
    '1 Slice of Shoulder': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Leg': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Shank': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Flank': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Breast': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Neck': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Back': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Loin': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Rib': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Chicken (White Meat)': {
    '1 Slice of White Meat': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Breast': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Duck (Wing)': {
    '1 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Frog (Frog Meat)': {
    '1 Piece (Big)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Pieces (Small)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Internal Organs': {
    '1/4 Cup of Liver': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Lungs': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Gizzard': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/2 Cup of Kidney': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Sticks of Small Intestine': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Blood': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/2 Cup of Spleen': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/2 Cup of Omasum': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Tendon': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Heart': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Small Intestine (Carabeef)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '3/4 Cup of Tripe (Beef)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Brain (Pork Beef Carabeef)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Tongue (Pork Beef)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Pork Intestine (Small Barbeque)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '7 Pieces of Chicken Heart': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Pork Ear (Barbeque)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Mackarel (Striped)': {
    '1/2 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Porgy (Freshwater)': {
    '1/2 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Milkfish': {
    '1 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Mudfish/Murrel (Striated)': {
    '1/2 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Caesio/Fusilier (Golden)': {
    '1/2 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Anchovy (Long-Jawed Whole)': {
    '1/3 Cup': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Anchovy (Long-Jawed Without Head)': {
    '1/4 Cup': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Anchovy Fry': {
    '1/2 Cup': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Scad (Round)': {
    '1 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Mackerel (Short-Bodied)': {
    '1 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Catfish (Freshwater)': {
    '1 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Surgeon Fish (Blue-Lined)': {
    '1/2 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Grouper (Spotted)': {
    '1/2 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Scad (Big-Eyed)': {
    '1 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Slipmouth (Common)': {
    '2 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Goatfish (Yellow-Striped)': {
    '1 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Tuna (Yellow-Fin)': {
    '1/2 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Sardine (Indian)': {
    '1 & 1/2 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Sardine (Bombon)': {
    '2 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Tilapia': {
    '1/2 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Tuna (Frigate/Bullet)': {
    '1/2 Slice': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Crab (Mud/Mangrove) Fat': {
    '1 Tablespoon': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Crab (Mud/Mangrove) Meat': {
    '1/2 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Crab (Blue Swimming) Fat': {
    '1 & 1/2 Tablespoon': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Crab (Blue Swimming) Meat': {
    '1 Piece': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Sea Cucumber': {
    '6 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Squid': {
    '2 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Crab (Shore)': {
    '6 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Shrimp': {
    '1/3 Cup of Sergestid': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/2 Piece of Giant Tiger Prawn': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '4 Pieces of Greasy Black': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Mollusks': {
    '1/3 Cup of Sakhalin Surf Clam (Cockles)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '22 Pieces of Hard Clam': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Abalone': {
    '3 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },
  'Snail Golden': {
    '12 Pieces': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Cheese': {
    '1/3 Cup of Cottage': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1 Slice of Cheddar (Pasteurized Processed)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1/3 Cup of Feta': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1 & 1/2 Slice of Gouda': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1/4 Cup of Parmesa (Grated)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '2 & 1/2 Tablespoons of Pimiento': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1 Slice of Edam': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },

  'Fish Product Canned': {
    '1/4 Cup of Tuna Flakes (In Brine)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '3 pieces of Sardines (In Spiced Oil)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/4 Cup of Tuna Flakes (In Vegetable Oil)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Daing/Dried': {
    '8 Pieces of Croaker (Plain)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Pieces of Mackerel (Striped)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1/3 Piece of Cod': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Nemipterid (Ribbon-Finned)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece Big/11 Pieces Small of Goby (Flat-Headed)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Grouper (Spotted)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '3 & 1/2 Pieces of Swordfish': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '7 Pieces of Slipmouth (Common)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Pieces of Sardine (Indian)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Tilapia': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Tuyo/Dried ': {
    '1/2 Cup of Shrimp (Sergestid)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '13 Pieces of Anchovy (Long-Jawed)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '4 Tablespoons of Shrimp (Small Marine)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 pieces of Squid': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '4 pieces of Slipmouth (Common)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 pieces of Sardine (Indian)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Tinapa/Smoked (': {
    '1/2 Piece of Scad (Round)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '3 Pieces of Sardine (Indian)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '3 Pieces of Sardine (Fimbriated)': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Milkfish': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },

  'Chicken': {
    '1 Piece of Leg/Drumstick': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Thigh': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Wing': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Pieces of Head': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Duck': {
    '1 Piece of Thigh': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Back': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Breast': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Egg': {
    '1 Piece Medium (Chicken Whole)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece Medium (Duck Whole Salted)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '7 Pieces Small (Quail)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Duck (Fertilized)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Piece of Duck (Unfertilized)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 piece of Duck (Whole)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Fish': {
    '1/2 Piece of Carp': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Canned': {
    '3 Slices of Runner (Two-Finned In Oil)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Pieces of Sardines (In Tomato sauce': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '2 Tablespoons of Tuna Spread': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Meat Products': {
    '1/4 Cup of Corned Beef': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '2 Pieces of Sausages/Ham': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1 Piece of Sausage (Chorizo)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1 & 1/2 Piece of Sausages (Frankfurter)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '2 Pieces of Sausage (Salami)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },

  'Nuts/Bean Products': {
    '1/2 Cup of Tofu': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '1 Piece of Tokwa': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '2 Tablespoons of Peanut (With Skin Roasted)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
    '2 Tablespoons of Peanut (Without Skin Roasted)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 3,
    },
  },

  'Chicken ': {
    '2 Pieces of Chick (One-Day-Old Fried)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '4 Pieces of Chicken Feet (Barbecue)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '3 Pieces of Chicken Head (Barbecue)': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Pork ': {
    '1 Slice of Picnic': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Belly (Less Fat)': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Ham': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Spare Rib': {
      'fats': 10,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Tenderloin': {
      'fats': 1,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
    '1 Slice of Leg': {
      'fats': 6,
      'carbs': 0,
      'proteins': 8,
      'foodExchange': 1,
      'type': 2,
    },
  },

  'Asparagus (Canned)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Baby Corn/Coung Corn (Canned)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Chickpea (Canned)': {
    '1 Tablespoon': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Green Peas (Canned Frozen)': {
    '1 Tablespoon': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Mixed Vegetables (Carrot Peas and Corn Frozen)': {
    '2 Tablespoons': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Mushroom (Whole Sliced Canned)': {
    '3/4 Cup': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Tomato (Canned)': {
    '3 Tablespoons': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Tomato Juice (Canned)': {
    '1/4 Cup': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },
  'Water chestnut (Canned)': {
    '4 Pieces': {
      'fats': 0,
      'carbs': 3,
      'proteins': 1,
      'foodExchange': 1,
      'type': 1,
    },
  },

  'Rattan fruit': {
    '13 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Starfruit': {
    '4 & 1/2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Guava (Red)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Guava (White)': {
    '3 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Bignay': {
    '2 Cups': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Blueberries': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Madras Thorn': {
    '7 Pods': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Cherries (Sweet Ripe)': {
    '7 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Sapodilla': {
    '1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Orange (Ladu/Szinkom)': {
    '3 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Jamaica Cherry': {
    '1/2 Cup or 25 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Dragon Fruit': {
    '1/2 Cup or 1/4 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Black/Java Plum': {
    '12 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Durian': {
    '2 Segments': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Pomegranate': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Soursop': {
    '1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Cashew Fruit': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Star Apple (Green)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Star Apple (Purple)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Jackfruit (Ripe)': {
    '1 & 1/2 Segments': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Lanzon': {
    '5 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Lychee': {
    '4 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Longan': {
    '13 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },

  'Ebony': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Curacao Apple': {
    '9 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Indian Unripe)': {
    '1/2 Cup or 1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Manila Super Unripe)': {
    '1/2 Cup or 1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Manila Super Medium Ripe)': {
    '1/2 Cup or 1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Manila Super Ripe)': {
    '1/2 Cup or 1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Paho Unripe)': {
    '9 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Piko Unripe)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Piko Ripe)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Piko Medium Ripe)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango (Supsupin Ripe)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mangosteen': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Jahore Oak': {
    '10 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Melon (Honey Dew)': {
    '3/4 cup or 1 slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Melon (Cantaloupe)': {
    '1 & 1/4 cup or 1 slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Melon (Musk)': {
    '1 & 1/4 cup or 1 slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Orange (Florida)': {
    '1/2 pc': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Orange (Kiat Kiat)': {
    '3 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Orange (Ponkan)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Papaya (Ripe)': {
    '3/4 cup or 1 slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Passion Fruit': {
    '1/4 cup or 2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },

  'Pear': {
    '3/4 Cup or 1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Persimmon': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Pineapple': {
    '1/2 Cup or 1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Rambutan': {
    '5 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Bungulan)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Cavendish Ripe)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Gloria)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Lakatan)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Latundan)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Violet)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Banana (Saba)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Tamarind (Ripe)': {
    '12 Segments': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Santol': {
    '1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Turnip (Tuber)': {
    '1 Cup or 1 & 1/2 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Spanish Plum': {
    '4 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Strawberry': {
    '1 & 1/4 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Pomelo': {
    '2 Segments': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Carristel': {
    '1/4 Piece or 1 Slice': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Grapes': {
    '12 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Lemon juice': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Coconut water': {
    '1 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Orange juice': {
    '1/3 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Passion fruit juice': {
    '1/4 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },

  'Apple Sauce (Sweetened)': {
    '4 Tablespoons': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Apple Sauce (Unsweetened)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Blackberries (Heavy Syrup Solids and Liquids)': {
    '1/4 Cup or 9 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Blueberries (Light Syrup Drained)': {
    '1/4 Cup or 29 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Fruit Cocktail (Tropical In Syrup)': {
    '1/4 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Lychee in Syrup': {
    '4 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Peach Halves in Heavy Syrup': {
    '1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Pineapple (Crushed/Tidbits/Chunks)': {
    '1/3 Cup': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Pineapple Slice': {
    '1 Ring': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Strawberries (Frozen Unsweetened)': {
    '3/4 Cup or 26 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Strawberries (Heavy Syrup Solids and Liquids)': {
    '1/4 Cup or 7 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Champoy': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Dates': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Dikyam': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Mango Chips': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },
  'Prunes': {
    '1 Piece': {
      'fats': 0,
      'carbs': 10,
      'proteins': 0,
      'foodExchange': 1,
      'type': 5,
    },
  },

  'Milk (Carabao)': {
    '3/4 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Cow)': {
    '1 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Evaporated)': {
    '1/2 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Evaporated Filled)': {
    '1/2 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Goat)': {
    '1 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Recombined)': {
    '3/4 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Powder Filled Instant)': {
    '5 Tablespoons': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Powder Full cream)': {
    '5 Tablespoons': {
      'carbs': 12,
      'proteins': 8,
      'fats': 10,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Low Fat)': {
    '1 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 5,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Buttermilk': {
    '3/4 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 0,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Skim)': {
    '1 Cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 0,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Powder Skim)': {
    '4 Tablespoons': {
      'carbs': 12,
      'proteins': 8,
      'fats': 0,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Milk (Powder Non-Fat Instant)': {
    '4 Tablespoons': {
      'carbs': 12,
      'proteins': 8,
      'fats': 0,
      'foodExchange': 1,
      'type': 3
    },
  },
  'Yogurt (Plain Skim)': {
    '1/2 cup': {
      'carbs': 12,
      'proteins': 8,
      'fats': 0,
      'foodExchange': 1,
      'type': 3
    },
  },

  'Rice (Protein Reduced)': {
    '1/3 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Ampaw (Pinipig)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Glutinous Biko)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Cuchinta)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous Sapin-Sapin)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cornstarch': {
    '1/4 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    }
  },
  'Corn Pudding (Maja Blanca)': {
    '1/2 Clice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Corn Pudding (Maja Mais Yellow)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Noodles (Rice)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Noodles (Wheat Thin)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Noodles (Mungbean Starch)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Noodles (Sweet Potato)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Taro': {
    '3/4 Cup (Cubed)': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Sweet Potato (Yellow Purple White)': {
    '1 Piece or 3/4 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cassava': {
    '1 Slice or 3/4 Cup (Cubed)': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cassava Cake (Bibingka)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cassava (Mashed With Sugar Margarine)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cassava (Pichi-Pichi)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cassava (Suman)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Yam (Spiny)': {
    '1 & 1/4 Cup (Cubed)': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Yam (Purple)': {
    '1 Cup (Cubed)': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Banana (Saba Boiled)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Palm Starch Ball (Boiled)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Tapioca Pearls': {
    '1/4 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 0,
      'foodExchange': 1,
      'type': 6
    },
  },

  'Rice (Well-Milled Boiled)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice (Undermilled Red Boiled)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice (Undermilled/Brown Boiled)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Gruel (Thin Consistency)': {
    '4 & 1/2 Cups': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    }
  },
  'Rice Gruel (Medium Consistency)': {
    '3 Cups': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Gruel (Thick Consistency)': {
    '1 & 1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Ampaw (Rice)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Bibingka)': {
    '1/2 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Glutinous Bibingka)': {
    '1/2 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Glutinous Pinipig)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Espasol)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous Kalamay With Coconut Curd Topping)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous With Yam)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous Palitaw)': {
    '3 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Brown)': {
    '1/2 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Puto Bumbong Purple)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Maya)': {
    '1/2 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Puto White)': {
    '1 Slice or 3-4 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice-Bread Prep (Toasted Puto Seko)': {
    '4 Pieces ': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice-Bread Prep (Toasted Puto Seko With Grated Coconut)': {
    '7 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },

  'Rice Prep (Glutinous With Grated Coconut Topping)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous Ibos)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous Lye-Treated)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Flour Prep (Tamales)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Cake (Glutinous Chinese Tikoy)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Rice Prep (Glutinous Tupig)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cookies (Apas)': {
    '7 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cookies (Lady Finger)': {
    '5 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cake (Mamon Toasted)': {
    '3 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Steamed Bun': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Hopyang Hapon': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cookies (Marie)': {
    '8 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cookies (Pasencia)': {
    '7 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cake (Jelly Roll)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Cake (Sponge)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Hominy (Binatog)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Corn Flakes': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Corn (Whole Kernel Canned)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Corn Cream Style (Canned)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Corn Grits (Yellow White)': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Corn on Cob (Yellow White)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Chestnut (Roasted)': {
    '8 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },
  'Plantains (Yellow White)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 2,
      'foodExchange': 1,
      'type': 6
    },
  },

  'Bread (Wheat)': {
    '1 & 1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Sweet Roll)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Hamburger Bun)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Hotdog Roll)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (White Loaf)': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pan de Bonete)': {
    '1 & 1/2 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pan de Leche)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pan de Limon)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pan de Monay)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pan de Sal)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pinagong)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pita White Enriched/Unenriched)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Pita Whole Wheat)': {
    '1/2 Piece': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Bread (Toast/Toasted)': {
    '5 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Couscous': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Pasta (Enriched/Unenriched)': {
    '1/2 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Udon': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Spring Roll Wrapper (Plain)': {
    '7 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Jackfruit (Seed)': {
    '14 Pieces': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },
  'Quinoa': {
    '1 Cup': {
      'fats': 0,
      'carbs': 23,
      'proteins': 4,
      'foodExchange': 1,
      'type': 6,
    },
  },

  'Sugar (Muscovado Brown White)': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Coconut Meat (Grated Sweetened)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Candy (Caramel Hard Toffee)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Cherry in Syrup': {
    '5 Pieces': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Chewing Gum (Bubble Gum)': {
    '1-2 Pieces': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Sugar (Coconut Sap)': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Syrup (Coconut Sap)': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dates (Pitted)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dried Jackfruit': {
    '1 pc (4 × 2.5 × 0.5 cm)': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dried Kiwi': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dried Mango': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dried Papaya Chunks': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dried Pineapple': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Dulce de Leche': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Milk (Sweetened Condensed Filled)': {
    '1 Teaspoon': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Carrageenan Gel (Assorted Fruit Flavor)': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Jam and Jellies': {
    '2 Teaspoons': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Kiamoy': {
    '2 Pieces': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Crème Custard (Leche Flan)': {
    '1 Slice': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },
  'Lokum': {
    '1 Piece': {
      'fats': 0,
      'carbs': 5,
      'proteins': 0,
      'foodExchange': 1,
      'type': 4,
    },
  },

  "Coco Honey": {
    "1 Teaspoon": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Nata De Coco (Nata De Piña Sweetened)": {
    "1 Tablespoon": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Sugar/Crude (Pakaskas Panocha)": {
    "1 Teaspoon": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Fudge (Durian Milk Jackfruit)": {
    "1 Piece": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Syrup (Molasses Cane)": {
    "2 Teaspoons": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Tamarind (Candied)": {
    "2 Pieces": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Soy Bean Curd (Gerlig's Cheese With Syrup and Sago)": {
    "1/4 Cup": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  },
  "Candy (Pulled)": {
    "1 Piece": {
      "fats": 0,
      "carbs": 5,
      "proteins": 0,
      "foodExchange": 1,
      "type": 4
    }
  }
};
