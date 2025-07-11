DELIMITER //

CREATE TRIGGER TRG_ATUALIZAR_STATUS_SESSAO
AFTER UPDATE ON SESSAO
FOR EACH ROW
BEGIN
    IF NEW.HORARIO_TERMINO <= NOW() AND NEW.STATUS_SESSAO <> 'ENCERRADA' THEN
        UPDATE SESSAO
        SET STATUS_SESSAO = 'ENCERRADA'
        WHERE ID_SESSAO = NEW.ID_SESSAO;
    END IF;
END;
//

CREATE TRIGGER TRG_REGISTRAR_VENDA_INGRESSO
AFTER INSERT ON INGRESSO
FOR EACH ROW
BEGIN
    IF NEW.STATUS_INGRESSO = 'VENDIDO' THEN
        INSERT INTO LOG_VENDAS_INGRESSOS (ID_INGRESSO, PRECO_VENDA, ID_SESSAO, ID_CLIENTE)
        VALUES (NEW.ID_INGRESSO, NEW.PRECO_FINAL, NEW.ID_SESSAO, NEW.ID_CLIENTE);
    END IF;
END;
//

DELIMITER ;

