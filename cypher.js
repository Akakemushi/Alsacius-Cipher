// cypher.js

const replacements1Encrypt = {
  'th': 'ï', 'Th': 'Ï',
  'ch': 'ù', 'Ch': 'Ù',
  'sh': 'ã', 'Sh': 'Ã',
  'ph': 'ñ', 'Ph': 'Ñ',
  'ing': 'é', 'Ing': 'É',
  'er': 'æ', 'Er': 'Æ'
};

const replacements2Encrypt = {
  'a': 'i', 'b': 't', 'c': 'q', 'd': 'g', 'e': 'u', 'f': 'j', 'g': 'p',
  'h': 'w', 'i': 'a', 'j': 'v', 'k': 'l', 'l': 'f', 'm': 'h', 'n': 'b',
  'o': 'y', 'p': 'm', 'q': 'x', 'r': 'c', 's': 'r', 't': 'z', 'u': 'e',
  'v': 's', 'w': 'd', 'x': 'k', 'y': 'o', 'z': 'n',
  'A': 'I', 'B': 'T', 'C': 'Q', 'D': 'G', 'E': 'U', 'F': 'J', 'G': 'P',
  'H': 'W', 'I': 'A', 'J': 'V', 'K': 'L', 'L': 'F', 'M': 'H', 'N': 'B',
  'O': 'Y', 'P': 'M', 'Q': 'X', 'R': 'C', 'S': 'R', 'T': 'Z', 'U': 'E',
  'V': 'S', 'W': 'D', 'X': 'K', 'Y': 'O', 'Z': 'N'
};

const replacements3Encrypt = {
  "can't": 'šcannot', "n't": ' šnot', "'re": ' šare', "'m": ' šam',
  "'ll": ' šwill', "'d": ' šwould', "'ve": ' šhave',
  "Can’t": 'Šcannot', "CAN’T": 'ŠCANNOT', "N’T": ' ŠNOT',
  "’RE": ' ŠARE', "’M": ' ŠAM', "’LL": ' ŠWILL', "’D": ' ŠWOULD', "’VE": ' ŠHAVE',
  "can’t": 'šcannot', "n’t": ' šnot', "’re": ' šare', "’m": ' šam',
  "’ll": ' šwill', "’d": ' šwould', "’ve": ' šhave'
};

const replacements2Decrypt = Object.fromEntries(Object.entries(replacements2Encrypt).map(([k, v]) => [v, k]));
const replacements1Decrypt = Object.fromEntries(Object.entries(replacements1Encrypt).map(([k, v]) => [v, k]));
const replacements3Decrypt = Object.fromEntries(Object.entries(replacements3Encrypt).map(([k, v]) => [v, k]));

function replaceCombinations(text, replacements) {
  for (const [key, val] of Object.entries(replacements)) {
    text = text.split(key).join(val);
  }
  return text;
}

function singlePassReplace(text, replacements) {
  return text.split('').map(char => replacements[char] || char).join('');
}

function replaceTwoLetters(text, replacements) {
  return text.split(" ").map(word => {
    const letters = [...word].filter(c => /[a-zA-Z]/.test(c)).length;
    if (letters === 2) {
      return [...word].map(c => /[a-zA-Z]/.test(c) ? (replacements[c] || c) : c).join('');
    }
    return word;
  }).join(" ");
}

function unwrapTildes(word) {
  return word.replace(/~([a-zA-Z])~/g, "$1");
}

function replaceKeyWordsEncrypt(text) {
  const wordArray = text.split(" ");
  const altered = [];

  for (let i = 0; i < wordArray.length; i++) {
    let word = wordArray[i];
    const chars = [...word];
    const letterCount = chars.filter(c => /[a-zA-Z]/.test(c)).length;

    if (letterCount === 1) {
      for (let j = 0; j < chars.length; j++) {
        const char = chars[j];
        if (/[iI]/.test(char)) {
          const rand = String.fromCharCode(97 + Math.floor(Math.random() * 13));
          const prevWord = wordArray[i - 1] || "";
          const isSentenceStart = !prevWord || /[.!?]$/.test(prevWord);
          chars[j] = isSentenceStart ? rand.toUpperCase() : rand;
        } else if (char === 'a') {
          chars[j] = String.fromCharCode(110 + Math.floor(Math.random() * 13));
        } else if (char === 'A') {
          chars[j] = String.fromCharCode(78 + Math.floor(Math.random() * 13));
        } else if (/[a-zA-Z]/.test(char)) {
          chars[j] = `~${char}~`;
        }
      }
      altered.push(chars.join(''));
    } else if (letterCount === 3 && /^\W*The\W*$/.test(word)) {
      altered.push(word.replace(/The/, 'Ø'));
    } else if (letterCount === 3 && /^\W*the\W*$/.test(word)) {
      altered.push(word.replace(/the/, 'ø'));
    } else {
      altered.push(word);
    }
  }
  return altered.join(" ");
}

function replaceKeyWordsDecrypt(text) {
  text = text.replace(/ø/g, "the").replace(/Ø/g, "The");

  const wordArray = text.split(" ");
  const altered = [];

  for (let i = 0; i < wordArray.length; i++) {
    let word = wordArray[i];
    const chars = [...word];
    const letterCount = chars.filter(c => /[a-zA-Z]/.test(c)).length;

    if (letterCount === 1) {
      if (/~[a-zA-Z]~/.test(word)) {
        altered.push(unwrapTildes(word));
      } else {
        for (let j = 0; j < chars.length; j++) {
          const char = chars[j];
          if (/[a-mA-M]/.test(char)) {
            chars[j] = "I";
          } else if (/[n-z]/.test(char)) {
            chars[j] = "a";
          } else if (/[N-Z]/.test(char)) {
            chars[j] = "A";
          }
        }
        altered.push(chars.join(""));
      }
    } else {
      altered.push(word);
    }
  }
  return altered.join(" ");
}

function fourFiveLetterRuleEncrypt(text) {
  const words = text.split(" ");
  let toggle = true;
  return words.map(word => {
    const chars = [...word];
    let letterCount = 0;
    let firstLetterIndex = null;
    let capitalLetterPresent = false;

    for (let i = 0; i < chars.length; i++) {
      if (/[a-zA-ZïÏùÙãÃñÑéÉæÆ]/.test(chars[i])) {
        if (letterCount === 0) firstLetterIndex = i;
        if (/[A-ZÏÙÃÑÉÆ]/.test(chars[i])) capitalLetterPresent = true;
        letterCount++;
      }
    }

    if ((letterCount === 4 || letterCount === 5) && toggle && firstLetterIndex !== null) {
      const insertIndex = firstLetterIndex + Math.floor(Math.random() * letterCount);
      const insertChar = capitalLetterPresent ? 'Ç' : 'ç';
      chars.splice(insertIndex, 0, insertChar);
      toggle = !toggle;
    } else if ((letterCount === 4 || letterCount === 5)) {
      toggle = !toggle;
    }

    return chars.join("");
  }).join(" ");
}

function fourFiveLetterRuleDecrypt(text) {
  text = text.replace(/ç/g, '');
  const words = text.split(" ");
  return words.map(word => {
    if (!word.includes("Ç")) return word;
    const chars = [...word];
    const indexes = [];
    chars.forEach((c, i) => {
      if (/[a-zA-ZïÏùÙãÃñÑéÉæÆÇ]/.test(c)) indexes.push(i);
    });
    if (indexes.length < 2) return word;
    const first = indexes[0];
    const second = indexes[1];
    chars[second] = chars[second].toUpperCase();
    chars.splice(first, 1);
    return chars.join('');
  }).join(" ");
}

function scrambleRuleEncrypt(text) {
  const words = text.split(" ");
  return words.map((word, i) => {
    if ((i + 1) % 4 !== 0) return word;
    const chars = [...word];
    let letterCount = 0, secondIndex = -1, secondChar = '', finalIndex = -1;
    for (let j = 0; j < chars.length; j++) {
      if (/[a-zA-ZïÏùÙãÃñÑéÉæÆçÇøØ]/.test(chars[j])) {
        letterCount++;
        finalIndex = j;
        if (letterCount === 2) {
          secondIndex = j;
          secondChar = chars[j];
        }
      }
    }
    if (letterCount >= 3) {
      chars.splice(finalIndex + 1, 0, secondChar);
      chars.splice(secondIndex, 1);
    }
    return chars.join('');
  }).join(" ");
}

function scrambleRuleDecrypt(text) {
  const words = text.split(" ");
  return words.map((word, i) => {
    if ((i + 1) % 4 !== 0) return word;
    const chars = [...word];
    let letterCount = 0, secondLetterIndex = 0, finalLetter = '', finalLetterIndex = 0;
    chars.forEach((char, c_index) => {
      if (/[a-zA-ZïÏùÙãÃñÑéÉæÆçÇ]/.test(char)) {
        letterCount++;
        finalLetterIndex = c_index;
        finalLetter = char;
        if (letterCount === 2) secondLetterIndex = c_index;
      }
    });
    if (letterCount >= 3) {
      chars.splice(finalLetterIndex, 1);
      chars.splice(secondLetterIndex, 0, finalLetter);
    }
    return chars.join('');
  }).join(" ");
}

function encrypt(message) {
  let result = message;
  result = replaceCombinations(result, replacements3Encrypt);
  result = replaceKeyWordsEncrypt(result);
  result = replaceTwoLetters(result, replacements2Encrypt);
  result = replaceCombinations(result, replacements1Encrypt);
  result = singlePassReplace(result, replacements2Encrypt);
  result = fourFiveLetterRuleEncrypt(result);
  result = scrambleRuleEncrypt(result);
  return result;
}

function decrypt(message) {
  let result = message;
  result = scrambleRuleDecrypt(result);
  result = fourFiveLetterRuleDecrypt(result);
  result = singlePassReplace(result, replacements2Decrypt);
  result = replaceCombinations(result, replacements1Decrypt);
  result = replaceTwoLetters(result, replacements2Decrypt);
  result = replaceKeyWordsDecrypt(result);
  result = replaceCombinations(result, replacements3Decrypt);
  return result;
}

// Hook it up to the page
window.addEventListener("DOMContentLoaded", () => {
  document.getElementById("encrypt-btn").addEventListener("click", () => {
    const input = document.getElementById("input-text").value;
    document.getElementById("output-text").textContent = encrypt(input);
  });

  document.getElementById("decrypt-btn").addEventListener("click", () => {
    const input = document.getElementById("decrypt-input-text").value;
    document.getElementById("decrypt-output-text").textContent = decrypt(input);
  });

  document.getElementById("copy-encrypt").addEventListener("click", () => {
    const text = document.getElementById("output-text").textContent;
    navigator.clipboard.writeText(text);
  });

  document.getElementById("copy-decrypt").addEventListener("click", () => {
    const text = document.getElementById("decrypt-output-text").textContent;
    navigator.clipboard.writeText(text);
  });
});
