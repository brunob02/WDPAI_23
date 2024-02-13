let plus = document.getElementById('plus')
let list = document.getElementById('ingredients-list')
let maxIngredients = 7

plus.addEventListener('click', addIngredient)

function addIngredient(e) {
  if (list.children.length < maxIngredients) {
    var newIngredient = document.createElement('div')
    newIngredient.className = 'ingredients field'

    let counter = document.querySelectorAll('.ingredients.field').length + 1
    newIngredient.id = 'ingredients-list' + counter

    var factor = createInputElement(
      'number',
      'factor',
      counter,
      '0.01',
      'factor',
      '0.01',
      true
    )
    var unit = createInputElement('text', 'unit', counter, '', 'unit', '', true)
    var ingredient_name = createInputElement(
      'text',
      'ingredient_name',
      counter,
      '50',
      'name',
      'name',
      true
    )

    var img_minus = document.createElement('img')
    img_minus.src = 'public/img/minus.png'
    img_minus.style.width = '7%'
    img_minus.style.marginTop = '0.2em'
    img_minus.style.verticalAlign = 'middle'
    img_minus.className = 'minus-btn'
    img_minus.setAttribute('data-list-id', newIngredient.id)

    img_minus.addEventListener('click', removeIngredient)

    newIngredient.appendChild(factor)
    newIngredient.appendChild(unit)
    newIngredient.appendChild(ingredient_name)
    newIngredient.appendChild(img_minus)

    list.appendChild(newIngredient)
  }
}

function createInputElement(
  type,
  name,
  counter,
  step,
  placeholder,
  min,
  required
) {
  var inputElement = document.createElement('input')
  if (name !== 'ingredient_name') {
    inputElement.style.width = '19%'
  } else {
    inputElement.style.width = '40%'
  }
  inputElement.type = type
  inputElement.name = name + counter
  inputElement.id = name + counter
  inputElement.step = step
  inputElement.placeholder = placeholder
  inputElement.min = min
  inputElement.required = required
  return inputElement
}

function removeIngredient(e) {
  var listId = e.target.getAttribute('data-list-id')
  var elementToRemove = document.getElementById(listId)

  if (elementToRemove) {
    elementToRemove.remove()
  }
}
