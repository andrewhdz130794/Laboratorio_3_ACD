import numpy as np
import pandas as pd

# Generación del dataset
d = 100  # número de columnas
n = 1000  # número de observaciones

# Matriz A con entradas aleatorias de una distribución normal
A = np.random.normal(0, 1, size=(n, d))

# Vector verdadero x* (coeficientes)
x_true = np.random.normal(0, 1, size=(d, 1))

# Vector b con ruido añadido
b = A.dot(x_true) + np.random.normal(0, 0.5, size=(n, 1))

# Solución cerrada
def closed_form_solution():
    # Generación del dataset
    d = 100  # número de columnas
    n = 1000  # número de observaciones

    # Matriz A con entradas aleatorias de una distribución normal
    A = np.random.normal(0, 1, size=(n, d))

    # Vector verdadero x* (coeficientes)
    x_true = np.random.normal(0, 1, size=(d, 1))

    # Vector b con ruido añadido
    b = A.dot(x_true) + np.random.normal(0, 0.5, size=(n, 1))
    x_solution =  np.linalg.inv(A.T.dot(A)).dot(A.T).dot(b)
    TableOut = pd.DataFrame({'xn' : x_solution.flatten()})
    return TableOut

# x_closed_form = closed_form_solution(A, b)

def gradient_descent(A, b, learning_rate, max_iter=1000, tolerance=1e-6):
    n, d = A.shape
    x = np.zeros((d, 1))  # Inicialización en ceros
    cost_history = []

    for i in range(max_iter):
        # Calculamos el gradiente
        grad = 2 * A.T.dot(A.dot(x) - b)
        # Actualizamos el vector de coeficientes
        x_new = x - learning_rate * grad
        # Calculamos el costo
        cost = np.sum((A.dot(x_new) - b) ** 2)
        cost_history.append(cost)

        # Criterio de convergencia
        if np.linalg.norm(x_new - x) < tolerance:
            break
        x = x_new

    return x, cost_history

def executeGd():
    # Ejecutamos el GD con diferentes tasas de aprendizaje
    learning_rates = [0.00005, 0.0005, 0.0007]
    results = []
    for idx, lr in enumerate(learning_rates, start=1):
        x, cost_history = gradient_descent(A, b, learning_rate=lr, max_iter=100)
        iter_data = pd.DataFrame({
            f'Iter_{idx}': np.arange(len(cost_history)),
            f'f_x_{idx}': np.array(cost_history).flatten(),
            f'Learning_rate_{idx}': lr
        })
        results.append(iter_data)

    TableOut = pd.concat(results, axis=1)
    return TableOut

def stochastic_gradient_descent(A, b, learning_rate, max_iter=1000):
    n, d = A.shape
    x = np.zeros((d, 1))  # Inicialización en ceros
    cost_history = []

    for i in range(max_iter):
        for j in range(n):
            # Seleccionamos una muestra al azar
            random_index = np.random.randint(n)
            a_j = A[random_index, :].reshape(1, d)
            b_j = b[random_index].reshape(1, 1)
            # Gradiente para una muestra
            grad = 2 * a_j.T.dot(a_j.dot(x) - b_j)
            # Actualizamos el vector de coeficientes
            x = x - learning_rate * grad
        # Costo después de cada iteración
        cost = np.sum((A.dot(x) - b) ** 2)
        cost_history.append(cost)

    return x, cost_history

def executeSGd():
    # Ejecutamos el SGD con diferentes tasas de aprendizaje
    learning_rates_sgd = [0.0005, 0.005, 0.01]
    sgd_results = []

    for idx, lr in enumerate(learning_rates_sgd, start = 1):
        x_sgd, cost_history_sgd = stochastic_gradient_descent(A, b, learning_rate=lr)
        iter_data = pd.DataFrame({
            f'Iter_{idx}': np.arange(len(cost_history_sgd)),
            f'f_x_{idx}': np.array(cost_history_sgd).flatten(),
            f'Learning_rate_{idx}': lr
        })
        sgd_results.append(iter_data)
    TableOut = pd.concat(sgd_results, axis=1)
    return TableOut

def mini_batch_gradient_descent(A, b, learning_rate, batch_size, max_iter=1000):
    n, d = A.shape
    x = np.zeros((d, 1))  # Inicialización en ceros
    cost_history = []

    for i in range(max_iter):
        # Permutar las filas de la matriz A
        permutation = np.random.permutation(n)
        A_shuffled = A[permutation]
        b_shuffled = b[permutation]

        # Actualizamos en lotes
        for j in range(0, n, batch_size):
            A_batch = A_shuffled[j:j+batch_size]
            b_batch = b_shuffled[j:j+batch_size]
            grad = 2 * A_batch.T.dot(A_batch.dot(x) - b_batch)
            x = x - learning_rate * grad

        # Costo después de cada iteración
        cost = np.sum((A.dot(x) - b) ** 2)
        cost_history.append(cost)

    return x, cost_history

# # Ejecutamos el MBGD con diferentes tamaños de batch y tasas de aprendizaje
# batch_sizes = [25, 50, 100]
# learning_rates_mbgd = [0.0005, 0.005, 0.01]
# mbgd_results = {}

# for batch_size in batch_sizes:
#     for lr in learning_rates_mbgd:
#         x_mbgd, cost_history_mbgd = mini_batch_gradient_descent(A, b, learning_rate=lr, batch_size=batch_size)
#         mbgd_results[(batch_size, lr)] = cost_history_mbgd


def rosenbrock(x1, x2):
    return 100 * (x2 - x1**2)**2 + (1 - x1)**2

def gradient_rosenbrock(x1, x2):
    dfdx1 = -400 * (x2 - x1**2) * x1 - 2 * (1 - x1)
    dfdx2 = 200 * (x2 - x1**2)
    return np.array([dfdx1, dfdx2])

def hessian_rosenbrock(x1, x2):
    d2fdx1x1 = 1200 * x1**2 - 400 * x2 + 2
    d2fdx1x2 = -400 * x1
    d2fdx2x2 = 200
    return np.array([[d2fdx1x1, d2fdx1x2], [d2fdx1x2, d2fdx2x2]])

def newton_method_rosenbrock(x_init, max_iter=1000, tol=1e-8):
    x = np.array(x_init)
    for i in range(max_iter):
        grad = gradient_rosenbrock(x[0], x[1])
        hess = hessian_rosenbrock(x[0], x[1])
        delta_x = np.linalg.inv(hess).dot(grad)
        x_new = x - delta_x

        if np.linalg.norm(grad) < tol:
            break

        x = x_new

    return x


# x_init = [0, 0]
# x_newton = newton_method_rosenbrock(x_init)
