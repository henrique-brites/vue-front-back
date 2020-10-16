--
-- Banco de dados: `devbage`
--
CREATE DATABASE IF NOT EXISTS devbage;
-- --------------------------------------------------------

--
-- Estrutura para tabela `item`
--

CREATE TABLE `item` (
  `id` bigint NOT NULL,
  `category` varchar(100) NOT NULL,
  `description` varchar(120) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Despejando dados para a tabela `item`
--

INSERT INTO `item` (`id`, `category`, `description`, `price`) VALUES
(1, 'Bebida', 'Água', '2.00'),
(2, 'Bebida', 'Suco', '10.00'),
(3, 'Bebida', 'Refrigerante', '12.00'),
(4, 'Comida', 'Pastel', '20.00'),
(5, 'Comida', 'Torrada', '10.00'),
(6, 'Sobremesa', 'Pudim', '5.00');

--
-- Índices de tabelas apagadas
--

--
-- Índices de tabela `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas apagadas
--

--
-- AUTO_INCREMENT de tabela `item`
--
ALTER TABLE `item`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;
