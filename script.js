/**
*  * QuickNotes - Core JavaScript Application Logic
  * Maintains all requirements: validation, adding, deleting, counting, and listing notes.
   */

// 1. Data Store: an array to hold note objects
   let notes = [];

/**
* Validates that a note's text is acceptable (1 to 200 characters after trimming).
     */
 function isValidNote(text) {
   const cleaned = text.trim();
    return cleaned.length > 0 && cleaned.length <= 200;
}

/**
* Adds a new note to the array if valid.
*/
 function addNote(text) {
if (!isValidNote(text)) {
console.log("❌ Note rejected:     must be 1-200 characters.");
  return false;
 }

const newNote = {
  id: Date.now(),
  text: text.trim(),
  createdAt: new Date().toLocaleString(),
 };

notes.push(newNote);
console.log(`✅ Added: "${newNote.text}"`);
return true;
}

/**
* Deletes a note by its unique ID.
 */
function deleteNote(id) {
  notes = notes.filter((note) => note.id !== id);
 }

/**
 * Returns a friendly summary sentence based on the total note count.
 */
  function countMessage() {
  if (notes.length === 0) return "You have no notes yet.";
  if (notes.length === 1) return "You have 1 note.";
  return `You have ${notes.length} notes.`;
}

/**
 *  * Prints all current notes and the summary message to the console.
*/
function listNotes() {
  notes.forEach((note, index) => {
    console.log(`${index + 1}. ${note.text} (${note.createdAt})`);
  });

console.log(countMessage());
 }

// --- Test Execution ---
addNote("Revise HTML forms");
addNote("   "); // Rejected due to empty space
addNote("Practise Flexbox");
listNotes();
                                         